require "optparse"

require "centra/cli/cli_utils"

module Centra
  class OrderImportCLI
    def self.parse!(name:, argv: ARGV)
      options = {
        centra_export_file: nil,
        anonymize: true,
        reset_tables: false,
      }

      db_options = {
        dbname: nil,
        host: nil,
        port: 5432,
        user: nil,
        password: nil,
        connect_timeout: 15,
      }

      OptionParser.new do |parser|
        parser.banner = "Usage: #{name} [options]"
        parser.default_argv = argv

        parser.on("--centra-export=centra_orders.csv", String, "Path to Centra order export file (in CSV format).") do |value|
          options[:centra_export_file] = value.strip
        end

        parser.on("--dbname=name", String, "Database name.") do |value|
          db_options[:dbname] = value.strip
        end

        parser.on("--host=dbhost.example.com", String, "Database host.") do |value|
          db_options[:host] = value.strip
        end

        parser.on("--user=username", String, "Database user.") do |value|
          db_options[:user] = value.strip
        end

        parser.on("--password=***", String, "Database password.") do |value|
          db_options[:password] = value
        end

        parser.on("--port=[5432]", Integer, "Database port.") do |value|
          db_options[:port] = value
        end

        parser.on("--connect_timeout=[15]", Integer, "Database connect timeout (in seconds).") do |value|
          db_options[:connect_timeout] = value
        end

        parser.on("--[no-]anonymize", "Anonymize/scrub personal details.") do |value|
          options[:anonymize] = value
        end

        parser.on("--[no-]reset-tables", "Drop and re-create database tables.") do |value|
          options[:reset_tables] = value
        end

        CLIUtils.parse_order_filter_args!(parser,  options)
        CLIUtils.parse_logger_args!(parser,  options)

        parser.on("-h", "--help", "How to use") do
          puts parser
          exit
        end

        parser.on_tail('--version', 'Show version') do
          puts "Centra version #{Centra::VERSION}"
          exit
        end

        # No argument, shows at tail. This will print an options summary.
        parser.on_tail("-h", "--help", "Show this message") do
          puts parser
          exit
        end
      end.parse!

      centra_export_file = options[:centra_export_file]
      if !centra_export_file || centra_export_file.empty?
        puts "You must provide a Centra export file path."
        puts "USAGE:"
        puts "    $ #{name} --help"
        exit 1
      end

      options[:db] = db_options
      options
    end
  end
end
