# frozen_string_literal: true

begin
  require "pg"
rescue LoadError
end

module Centra
  module DB
    class Connection
      include Loggable

      attr_reader :options

      OPTIONS_ENV_NAME_MAP = {
        dbname: "CENTRA_DB_NAME",
        host: "CENTRA_DB_HOST",
        user: "CENTRA_DB_USER",
        password: "CENTRA_DB_PASSWORD",
        port: "CENTRA_DB_PORT",
        connect_timeout: "CENTRA_DB_CONNECT_TIMEOUT"
      }.freeze

      # Initializes a database connection
      def initialize(**options)
        unless Object.const_defined?(:PG)
          raise(ArgumentError, "unable to require 'pg' gem")
        end

        unknown_keys = options.keys - OPTIONS_ENV_NAME_MAP.keys
        if unknown_keys.any?
          raise(ArgumentError, "unkown keys: #{unknown_keys.join(', ')}")
        end

        @options = options_config_env(options)
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

      private

      def options_config_env(opts)
        {
          dbname: option_config_env(opts, :dbname, true),
          host: option_config_env(opts, :host, true),
          port: Integer(option_config_env(opts, :port, false) || 5432),
          user: option_config_env(opts, :user, true),
          password: option_config_env(opts, :password, true),
          connect_timeout: Integer(option_config_env(opts, :connect_timeout, false) || 15)
        }.freeze
      end

      def option_config_env(options, name, required = false)
        return options[name] if options.key?(name)

        # Check config
        config_value = Centra.config.database[name.to_s]
        return config_value if config_value

        # Check environment
        env_name = OPTIONS_ENV_NAME_MAP.fetch(name)
        return ENV[env_name] if ENV[env_name]

        # Don't raise unless value presence is required
        return unless required
        raise(ArgumentError, "missing keyword: #{name}")
      end
    end
  end
end
