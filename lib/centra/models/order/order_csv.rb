module Centra
  class OrderCSV < ModelCSV
    column_map(
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
    )

    type_map(
      order_date: :datetime!,
      captured_date: :datetime_or_unix_epoch,
      pcs: :integer_or_zero,
      total_order_value_sek: :decimal_or_zero,
      vat_deduct: :decimal_or_zero,
      captured: :decimal_or_zero,
      product_order_value_ex_vat: :decimal_or_zero,
      shipping_value_ex_vat: :decimal_or_zero,
      voucher_value_ex_vat: :decimal_or_zero,
      total_order_value_ex_vat: :decimal_or_zero,
      vat: :decimal_or_zero,
      total_order_value_inc_vat: :decimal_or_zero,
      refunded: :decimal_or_zero,
      currency_rate: :decimal_or_zero,
      vat_sek: :decimal_or_zero,
      shipping_value_ex_vat_sek: :decimal_or_zero,
      voucher_value_ex_vat_sek: :decimal_or_zero,
    )

    anonymize_type_map(
      delivery_email: :md5,
      payment_reference: :nil,
    )

    class RowBuilder
      # All these fields might not be in the CSV-export
       MAYBE_FIELDS = %i[
         billing_name billing_company billing_address billing_coaddress billing_zipcode
         delivery_name delivery_company delivery_address delivery_coaddress delivery_zipcode
       ].freeze

      def initialize(anonymize = true)
        @anonymize = anonymize
        @fields = MAYBE_FIELDS.dup
      end

      def call(row)
        anonymize!(row) if @anonymize
        Order.new(row)
      end

      def anonymize!(row)
        converter = HoneyFormat.value_converter[:md5]
        missing = []
        @fields.each do |field|
          next missing << field unless row.respond_to?(field)
          row[field] = converter.call(row[field])
        end

        # Since all rows will have the same columns we remove
        # all fields that have not been found
        @fields = @fields - missing
      end
    end

    def initialize(csv_string, anonymize: true)
      super(csv_string, row_builder: RowBuilder.new(anonymize), anonymize: anonymize)
    end
  end
end
