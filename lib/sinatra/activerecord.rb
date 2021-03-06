require 'sinatra/base'
require 'active_record'
require 'active_support/core_ext/hash/keys'
require 'active_record/connection_adapters/empostgresql_adapter'

require 'logger'
require 'pathname'
require 'yaml'
require 'erb'

module Sinatra
  module ActiveRecordHelper
    def database
      settings.database
    end
  end

  module ActiveRecordExtension
    def self.registered(app)
      if ENV['DATABASE_URL']
        app.set :database, ENV['DATABASE_URL']
      elsif File.exist?("#{Dir.pwd}/config/database.yml")
        app.set :database_file, "#{Dir.pwd}/config/database.yml" 
      end
      
      unless defined?(Rake) || [:test, :production].include?(app.settings.environment)
        ActiveRecord::Base.logger = Logger.new(STDOUT)
      end

      app.helpers ActiveRecordHelper

      # re-connect if database connection dropped (Rails 3 only)
      app.before { ActiveRecord::Base.verify_active_connections! if ActiveRecord::Base.respond_to?(:verify_active_connections!) }
      app.use ActiveRecord::ConnectionAdapters::ConnectionManagement
    end

    def database_file=(path)
      path = File.join(root, path) if Pathname(path).relative? and root
      spec = YAML.load(ERB.new(File.read(path)).result) || {}
      set :database, spec
    end

    def database=(spec)
      if spec.is_a?(Hash) and spec.symbolize_keys[environment.to_sym]
        ActiveRecord::Base.configurations = spec.stringify_keys
        ActiveRecord::Base.establish_connection(environment.to_sym)
      else
        ActiveRecord::Base.establish_connection(spec)
        ActiveRecord::Base.configurations ||= {}
        ActiveRecord::Base.configurations[environment.to_s] = ActiveRecord::Base.connection.pool.spec.config
      end
    end

    def database
      ActiveRecord::Base
    end
  end

  register ActiveRecordExtension
end
