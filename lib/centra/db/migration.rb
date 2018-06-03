# frozen_string_literal: true

module Centra
  module DB
    class Migration
      include Loggable

      # Initializes a database migration
      # @param [Centra::DB::Connection] the database connection
      def initialize(connection)
        @connection = connection
      end

      # Perform migration
      def up
        raise(NotImplementedError, 'this method should be implemented in subclass')
      end

      # Undo migration
      def down
        raise(NotImplementedError, 'this method should be implemented in subclass')
      end

      protected

      # Executes SQL on current database connection
      # @param [String] the SQL string to execute
      def execute(sql)
        @connection.execute(sql)
      end
    end
  end
end
