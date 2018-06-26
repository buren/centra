require "time"
require "optparse"

require "centra/cli/cli_utils"

module Centra
  module Rule
    class CLI
      attr_reader :options

      def initialize(name:, argv: ARGV)
        @name = name
        @options = {}
        @optparser = nil
        parse_options(argv, @name, @options)
      end

      def help
        @optparser.help
      end

      private

      def parse_options(argv, name, options)
        @optparser = OptionParser.new do |parser|
          parser.banner = "Usage: #{name} [options]"

          parser.default_argv = argv

          parser.on('--rule=rule_export.csv', String, 'Path to Rule export file') do |value|
            options[:rule_orders_path] = value
          end

          parser.on('--centra=centra_export.csv', String, 'Path to Centra orders export file') do |value|
            options[:centra_orders_path] = value
          end

          parser.on('--max-allowed-diff=[90]', Integer, 'Max number of minutes allowed between order timestamps') do |value|
            options[:allowed_delay_in_minutes] = value
          end

          parser.on('--output-missing=[missing.csv]', String, 'Path to missing CSV output path') do |value|
            options[:missing_output] = value
          end

          parser.on('--output-matched=[matched.csv]', String, 'Path to matched CSV output path') do |value|
            options[:matched_output] = value
          end

          CLIUtils.parse_order_filter_args!(parser,  options)
          CLIUtils.parse_logger_args!(parser,  options)

          # No argument, shows at tail. This will print an options summary.
          parser.on_tail('-h', '--help', 'Show this message') do
            puts parser
            exit
          end
        end

        @optparser.parse!
      end
    end
  end
end
