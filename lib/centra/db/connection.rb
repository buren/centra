# frozen_string_literal: true

begin
  require 'pg'
rescue LoadError
end

module Centra
  module DB
    class Connection
      include Loggable

      # Initializes a database connection
      def initialize(dbname:, host:, user:, password:, port: 5432, connect_timeout: 10)
        unless Object.const_defined?(:PG)
          raise(ArgumentError, "unable to require 'pg' gem")
        end

        @options =  {
          dbname: dbname,
          host: host,
          port: Integer(port),
          user: user,
          password: password,
          connect_timeout: connect_timeout
        }
        @connection = nil
      end

      def connection
        @connection ||= begin
          log.debug("Connecting to PG server with options: #{@options}")
          PG.connect(@options)
        end
      end

      # @param [String] sql the SQL-string to execute
      # @return [PG::Result] the result
      # @see https://deveiate.org/code/pg/PG/Connection.html#method-i-exec-doc
      def execute(sql)
        log.debug("Executing SQL: #{sql}")
        connection.exec(sql)
      end

      # @param [String] sql the copy SQL-string to execute
      # @return [PG::Result] the result
      # @see https://deveiate.org/code/pg/PG/Connection.html#method-i-copy_data-doc
      def copy_data(sql)
        log.debug("Executing COPY SQL: #{sql}")
        connection.copy_data(sql) { yield(connection) }
      end
    end
  end
end
