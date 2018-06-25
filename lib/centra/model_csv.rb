require "honey_format"
require "centra/csv_header_converter"

module Centra
  class ModelCSV
    def self.header_converter
      CSVHeaderConverter.new(self::COLUMN_MAP)
    end

    include Enumerable

    def initialize(csv_string, row_builder:)
      @csv = HoneyFormat::CSV.new(
        csv_string,
        header_converter: header_converter,
        row_builder: row_builder
      )
    end

    def header_converter
      self.class.header_converter
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
      "#<#{self.class.name}:#{"0x00%x" % (object_id << 1)}(header: #{header.join(', ')})"
    end
  end
end
