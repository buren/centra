require "optparse"

require "centra/cli/cli_utils"

module Centra
  class ImportCLI
    def self.parse!(name:, argv: ARGV)
      options = {
        centra_export_file: nil,
        anonymize: true,
        reset_tables: false,
        table_names: {},
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

        parser.on("--[no-]anonymize", "Anonymize/scrub personal details.") do |value|
          options[:anonymize] = value
        end

        CLIUtils.parse_database_connection_options!(parser, db_options)
        CLIUtils.parse_database_table_options!(parser, options)
        CLIUtils.parse_logger_args!(parser, options)
        CLIUtils.parse_cli_boilerplate_options!(parser)
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
