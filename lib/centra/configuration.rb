require "centra/db/database_tables"

module Centra
  class Configuration
    attr_accessor :logger, :database

    DatabaseConfig = Struct.new(
      :table_names,
      # Connection options
      :dbname, :host, :port, :user, :password, :connect_timeout
    )

    def initialize
      @logger = NullLogger.new
      @database = DatabaseConfig.new(DatabaseTables.new)
    end
  end
end
