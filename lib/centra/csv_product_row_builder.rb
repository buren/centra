# frozen_string_literal: true

require "centra/csv_row_builder"
require "centra/product"

module Centra
  class CSVProductRowBuilder < CSVRowBuilder
    # remove potentially sensitive data
    def anonymize!(row)
      row.email = anon_value_for(row.email)
    end

    def row_klass
      Product
    end
  end
end
