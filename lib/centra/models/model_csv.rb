require "honey_format"

module Centra
  class ModelCSV
    def self.header_converter
      CSVHeaderConverter.new(column_map)
    end

    def self.column_map(map = nil)
      @column_map ||= {}
      return @column_map unless map
      @column_map.merge!(map)
    end

    def self.type_map(map = nil)
      @type_map ||= {}
      return @type_map unless map
      @type_map.merge!(map)
    end

    def self.anonymize_type_map(map = nil)
      @anonymize_type_map ||= {}
      return @anonymize_type_map unless map
      @anonymize_type_map.merge!(map)
    end

    include Enumerable

    def initialize(csv_string, row_builder:, anonymize: true)
      @anonymize = anonymize
      @csv = HoneyFormat::CSV.new(
        csv_string,
        header_converter: header_converter,
        row_builder: row_builder,
        type_map: type_map
      )
    end

    def anonymize?
      @anonymize
    end

    def header_converter
      self.class.header_converter
    end

    def type_map
      default_map = self.class.type_map
      return default_map unless anonymize?

      default_map.merge(self.class.anonymize_type_map)
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
      "#<#{self.class.name}:#{"0x00%x" % (object_id << 1)}(header: #{@csv&.header&.join(', ')})"
    end
  end
end
