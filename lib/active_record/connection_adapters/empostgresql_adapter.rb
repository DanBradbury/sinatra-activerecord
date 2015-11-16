require 'active_record/connection_adapters/postgresql_adapter'
require 'active_record/connection_adapters/statement_pool'

module ActiveRecord
  module ConnectionAdapters
    class EMPostgreSQLAdapter < PostgreSQLAdapter
      def initialize
        super
      end

      def adapter_name
        "EMpg".freeze
      end
    end
  end
end

