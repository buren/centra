require "centra/model_csv"
require "centra/csv_product_row_builder"

module Centra
  class ProductCSV < ModelCSV
      COLUMN_MAP = {
        "Order" => :order,
        "Email" => :email,
        "Newsletter" => :newsletter,
        "Created" => :created_at,
        "Country" => :country,
        "Brand" => :brand,
        "SKU" => :sku,
        "Product" => :product_name,
        "Variant" => :variant,
        "Folder" => :folder,
        "Size" => :size,
        "Qty" => :quantity,
        "Total" => :total,
        "Total VAT" => :total_vat,
        "Currency" => :currency,
        "Base Total" => :base_total,
        "Base Total VAT" => :base_total_vat,
        "Base Currency" => :base_currency,
      }.freeze

    def initialize(csv_string, anonymize: true)
      row_builder = CSVProductRowBuilder.new(anonymize: anonymize)
      super(csv_string, row_builder: row_builder)
    end
  end
end
