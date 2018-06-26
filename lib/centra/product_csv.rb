require "centra/model_csv"

module Centra
  class ProductCSV < ModelCSV
    COLUMN_MAP = {
      "Order" => :order_id,
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

    TYPE_MAP = {
      email: :md5,
      newsletter: :boolean,
      created_at: :datetime,
      quantity: :integer,
      total: :decimal,
      total_vat: :decimal,
      base_total: :decimal,
      base_total_vat: :decimal,
    }.freeze

    def initialize(csv_string, anonymize: true)
      super(csv_string, row_builder: ->(row) { Product.new(row) })
    end
  end
end
