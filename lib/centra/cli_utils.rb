require "time"

module Centra
  module CLIUtils
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
  end
end
