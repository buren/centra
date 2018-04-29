require "securerandom"
require "honey_format"

require "centra/csv_header_converter"

module Centra
  class OrderData
    include Enumerable

    def initialize(file)
      @csv = parse_csv(file)
      @rows = nil
    end

    def header
      @csv.header
    end

    def rows
      @csv.rows
    end

    def each(&block)
      rows.each(&block)
    end

    def anonymize!
      cache = AnonValue.new

      rows.each do |row|
        email = row.delivery_email
        # make sure the same email gets the same anonymized email
        row.delivery_email = cache.value_for(email) { "#{SecureRandom.uuid}@example.com" }
      end
    end

    def inspect
      "#<CentraData:#{"0x00%x" % (object_id << 1)}(header: #{header})"
    end

    private

    def parse_csv(string)
      HoneyFormat::CSV.new(string, header_converter: Centra::CSVHeaderConverter)
    end

    # Consistently anonymize a value
    class AnonValue
      def value_for(value)
        (@data ||= {}).fetch(value) { @data[value] = yield }
      end
    end
  end
end
