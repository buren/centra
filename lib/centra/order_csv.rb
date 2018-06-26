require "centra/model_csv"
require "centra/csv_order_row_builder"

module Centra
  class OrderCSV < ModelCSV
    COLUMN_MAP = {
      "Order" => :order_id,
      "Order Date" => :order_date,
      "Paytype" => :paytype,
      "Payment Method Code" => :payment_method_code,
      "Payment Reference" => :payment_reference,
      "Captured" => :captured,
      "Captured Date" => :captured_date,
      "Billing Country" => :billing_country,
      "Billing Name" => :billing_name,
      "Billing Company" => :billing_company,
      "Billing Address" => :billing_address,
      "Billing Coaddress" => :billing_coaddress,
      "Billing Zipcode" => :billing_zipcode,
      "Billing State" => :billing_state,
      "Billing City" => :billing_city,
      "Delivery Country" => :delivery_country,
      "Delivery Name" => :delivery_name,
      "Delivery Company" => :delivery_company,
      "Delivery Address" => :delivery_address,
      "Delivery Coaddress" => :delivery_coaddress,
      "Delivery Zipcode" => :delivery_zipcode,
      "Delivery State" => :delivery_state,
      "Delivery City" => :delivery_city,
      "Delivery Email" => :delivery_email,
      "Pcs" => :pcs,
      "Product Order Value (ex VAT)" => :product_order_value_ex_vat,
      "Shipping Value (ex VAT)" => :shipping_value_ex_vat,
      "Voucher Value (ex VAT)" => :voucher_value_ex_vat,
      "Total Order Value (ex VAT)" => :total_order_value_ex_vat,
      "VAT Deduct" => :vat_deduct,
      "VAT" => :vat,
      "Total Order Value (inc VAT)" => :total_order_value_inc_vat,
      "Refunded" => :refunded,
      "Currency" => :currency,
      "Currency Rate" => :currency_rate,
      "Total Order Value (SEK)" => :total_order_value_sek,
      "VAT (SEK)" => :vat_sek,
      "Shipping Value (ex VAT) (SEK)" => :shipping_value_ex_vat_sek,
      "Voucher Value (ex VAT) (SEK)" => :voucher_value_ex_vat_sek,
      "Affiliate" => :affiliate,
      "EC Vat" => :ec_vat,
      "VAT#" => :vat_pound,
      "Collection" => :collection,
    }.freeze


    TYPE_MAP = {
      order_date: :datetime!,
      captured_date: :datetime_or_unix_epoch,
      pcs: :integer,
      total_order_value_sek: :decimal,
      vat_deduct: :decimal,
      captured: :decimal,
      product_order_value_ex_vat: :decimal,
      shipping_value_ex_vat: :decimal,
      voucher_value_ex_vat: :decimal,
      total_order_value_ex_vat: :decimal,
      vat: :decimal,
      total_order_value_inc_vat: :decimal,
      refunded: :decimal,
      currency_rate: :decimal,
      vat_sek: :decimal,
      shipping_value_ex_vat_sek: :decimal,
      voucher_value_ex_vat_sek: :decimal,
    }.freeze

    def initialize(csv_string, anonymize: true)
      row_builder = CSVOrderRowBuilder.new(anonymize: anonymize)
      super(csv_string, row_builder: row_builder)
    end
  end
end
