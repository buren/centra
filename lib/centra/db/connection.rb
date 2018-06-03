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

        @connection = PG.connect(
          dbname: dbname,
          host: host,
          port: Integer(port),
          user: user,
          password: password,
          connect_timeout: connect_timeout
        )
      end

      # @return [PG::Result] the result
      # @see https://deveiate.org/code/pg/PG/Result.html
      def execute(sql)
        log.debug("Executing SQL: #{sql}")
        @connection.exec(sql)
      end
    end
  end
end
