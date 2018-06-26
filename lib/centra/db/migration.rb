# frozen_string_literal: true

require "centra/db/connection"

module Centra
  module DB
    class Migration
      include Loggable

      # Initializes a database migration
      # @param [Centra::DB::Connection] the database connection
      def initialize(connection = Connection.new)
        @connection = connection
      end

      # Perform migration
      def up
        raise(NotImplementedError, "this method should be implemented in subclass")
      end

      # Undo migration
      def down
        raise(NotImplementedError, "this method should be implemented in subclass")
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
