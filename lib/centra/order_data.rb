require "securerandom"
require "honey_format"

require "centra/csv_header_converter"
require "centra/csv_row_builder"

module Centra
  class OrderData
    include Enumerable

    def initialize(csv_string, anonymize: true)
      @csv = HoneyFormat::CSV.new(
        csv_string,
        header_converter: CSVHeaderConverter,
        row_builder: CSVRowBuilder.new(anonymize: anonymize)
      )
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

    def inspect
      "#<CentraData:#{"0x00%x" % (object_id << 1)}(header: #{header})"
    end
  end
end
