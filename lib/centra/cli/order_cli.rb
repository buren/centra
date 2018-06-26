# frozen_string_literal: true

require "optparse"

module Centra
  class OrderCLI
    def self.parse!(name:, argv: ARGV)
      options = {
        centra_export_file: nil,
        order_freq_output: nil,
        anonymized_output: nil,
        anonymize: true
      }

      OptionParser.new do |parser|
        parser.banner = "Usage: #{name} [options]"
        parser.default_argv = argv

        parser.on("--centra-export=centra_orders.csv", String, "Path to Centra order export file (in CSV format).") do |value|
          options[:centra_export_file] = value.strip
        end

        parser.on("--order-frequency-output=unique_emails.csv", String, "Path to output file.") do |value|
          options[:order_freq_output] = value.strip
          # Ensure file ending
          options[:order_freq_output] = "#{order_freq_output}.csv" unless value.end_with?(".csv")
        end

        parser.on("--anonymized-output=anonymized_orders.csv", String, "Path to output file.") do |value|
          options[:anonymized_output] = value.strip
          # Ensure file ending
          options[:anonymized_output] = "#{anonymized_output}.csv" unless value.end_with?(".csv")
        end

        parser.on("--[no-]anonymize", "Anonymize/scrub personal details.") do |value|
          options[:anonymize] = value
        end

        CLIUtils.parse_order_filter_args!(parser, options)
        CLIUtils.parse_logger_args!(parser, options)

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
      end.parse!

      centra_export_file = options[:centra_export_file]
      if centra_export_file.blank?
        puts "You must provide a Centra export file path."
        puts "USAGE:"
        puts "    $ #{name} --help"
        exit 1
      end

      options
    end
  end
end
