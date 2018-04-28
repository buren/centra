# CSV-header
class CSVHeader
  CENTRA_HEADER_MAP = {
    email: 'Delivery Email',
    pcs: 'Pcs',
    total_order_value_sek: 'Total Order Value (SEK)',
  }.freeze

  attr_reader :columns

  def initialize(columns)
    @columns = columns
    @header_cache = {}
  end

  def find_index(field)
    return @header_cache[field] if @header_cache[field]

    columns.each_with_index do |column, index|
      if column == CENTRA_HEADER_MAP.fetch(field, field)
        @header_cache[field] = index
        return index
      end
    end

    raise(ArgumentError, "no header column found for '#{field}'")
  end
end
