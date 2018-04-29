module Centra
  class CLI
    def self.parse!(argv: ARGV)
      centra_export_file = nil
      order_freq_output = nil
      anonymized_output = nil
      anonymize = true

      OptionParser.new do |parser|
        parser.banner = 'Usage: ruby centra_stats.rb [options]'
        parser.default_argv = argv

        parser.on('--centra-export=centra_orders.csv', String, 'Path to Centra order export file (in CSV format).') do |value|
          centra_export_file = value.strip
        end

        parser.on('--order-frequency-output=unique_emails.csv', String, 'Path to output file.') do |value|
          order_freq_output = value.strip
          # Ensure file ending
          order_freq_output = "#{order_freq_output}.csv" unless value.end_with?('.csv')
        end

        parser.on('--anonymized-output=anonymized_orders.csv', String, 'Path to output file.') do |value|
          anonymized_output = value.strip
          # Ensure file ending
          anonymized_output = "#{anonymized_output}.csv" unless value.end_with?('.csv')
        end

        parser.on('--[no-]anonymize', 'Anonymize/scrub personal details.') do |value|
          anonymize = value
        end

        parser.on('-h', '--help', 'How to use') do
          puts parser
          exit
        end

        # No argument, shows at tail. This will print an options summary.
        parser.on_tail('-h', '--help', 'Show this message') do
          puts parser
          exit
        end
      end.parse!

      if !centra_export_file || centra_export_file.empty?
        puts 'You must provide a Centra export file path.'
        puts 'USAGE:'
        puts '    $ ruby unique_centra_emails.rb --help'
        exit 1
      end

      {
        centra_export_file: centra_export_file,
        order_freq_output: order_freq_output,
        anonymized_output: anonymized_output,
        anonymize: anonymize
      }
    end
  end
end
