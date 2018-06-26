require "time"

module Centra
  module CLIUtils
    def self.parse_logger_args!(parser, options)
      parser.on('--logger=[STDOUT]', String, 'STDOUT, /path/to/file or "none"') do |value|
        logger = case value
                 when nil, 'STDOUT', 'stdout' then Logger.new(STDOUT)
                 when 'none' then Centra::NullLogger.new
                 else
                   Logger.new(value)
                 end
        options[:logger] = logger
      end
    end

    def self.parse_order_filter_args!(parser, options)
      parser.on('--countries=[SE,NO]', Array, 'Only look at orders from certain countries (i.e SE,NO)') do |values|
        options[:countries] = values.map(&:upcase)
      end

      parser.on('--start-date=[2018-01-01]', 'Start date (YYYY-MM-DD)') do |value|
        options[:start_date] = Time.parse(value)
      end

      parser.on('--end-date=[2018-02-01]', 'End date (YYYY-MM-DD)') do |value|
        options[:end_date] = Time.parse(value)
      end
    end

    def self.parse_database_connection_options!(parser, options)
      parser.on("--dbname=name", String, "Database name.") do |value|
        options[:dbname] = value.strip
      end

      parser.on("--host=dbhost.example.com", String, "Database host.") do |value|
        options[:host] = value.strip
      end

      parser.on("--user=username", String, "Database user.") do |value|
        options[:user] = value.strip
      end

      parser.on("--password=***", String, "Database password.") do |value|
        options[:password] = value
      end

      parser.on("--port=[5432]", Integer, "Database port.") do |value|
        options[:port] = value
      end

      parser.on("--connect_timeout=[15]", Integer, "Database connect timeout (in seconds).") do |value|
        options[:connect_timeout] = value
      end
    end

    def self.parse_database_table_options!(parser, options)
      parser.on("--[no-]reset-tables", "Drop and re-create database tables.") do |value|
        options[:reset_tables] = value
      end

      parser.on('--table-names=[name=newname,name1=newname1]', Array, 'Customize default database table names.') do |value|
        options[:table_names] = (value || []).map { |v| v.split('=') }.to_h
      end
    end

    def self.parse_cli_boilerplate_options!(parser)
      parser.on("-h", "--help", "How to use") do
        puts parser
        exit
      end

      parser.on_tail("--version", "Show version") do
        puts "Centra version #{Centra::VERSION}"
        exit
      end

      # No argument, shows at tail. This will print an options summary.
      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end
    end
  end
end
