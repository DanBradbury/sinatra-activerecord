gem 'pg'
require 'pg'

require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/connection_adapters/statement_pool'

module ActiveRecord
  module ConnectionHandling
    def empostgresql_connection(config)
    end
  end

  module ConnectionAdapters
    class EMPostgreSQLAdapter < PostgreSQLAdapter
      ADAPTER_NAME = "EMPostgreSQL".freeze
    end
  end
end

