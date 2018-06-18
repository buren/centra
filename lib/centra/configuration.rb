require "centra/db/database_tables"

module Centra
  class Configuration
    attr_accessor :logger, :database

    DatabaseConfig = Struct.new(:table_names)

    def initialize
      @logger = NullLogger.new
      @database = DatabaseConfig.new(DatabaseTables.new)
    end
  end
end
