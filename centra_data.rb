require 'securerandom'
require 'honey_format'

require_relative 'centra_csv_header_converter'

class CentraData
  def initialize(file)
    @csv = parse_csv(file)
  end

  def header
    @csv.header
  end

  def rows
    @csv.rows
  end

  def column_index(name)
    header.find_index(name)
  end
  alias_method :col_index, :column_index

  def columns
    header.columns
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
    HoneyFormat::CSV.new(string, header_converter: HeaderConverter)
  end

  # Consistently anonymize a value
  class AnonValue
    def value_for(value)
      (@data ||= {}).fetch(value) { @data[value] = yield }
    end
  end

  class HeaderConverter
    MAP = {
      'Order' => :order,
      'Order Date' => :order_date,
      'Paytype' => :paytype,
      'Payment Method Code' => :payment_method_code,
      'Payment Reference' => :payment_reference,
      'Captured' => :captured,
      'Captured Date' => :captured_date,
      'Billing Country' => :billing_country,
      'Billing Name' => :billing_name,
      'Billing Company' => :billing_company,
      'Billing Address' => :billing_address,
      'Billing Coaddress' => :billing_coaddress,
      'Billing Zipcode' => :billing_zipcode,
      'Billing State' => :billing_state,
      'Billing City' => :billing_city,
      'Delivery Country' => :delivery_country,
      'Delivery Name' => :delivery_name,
      'Delivery Company' => :delivery_company,
      'Delivery Address' => :delivery_address,
      'Delivery Coaddress' => :delivery_coaddress,
      'Delivery Zipcode' => :delivery_zipcode,
      'Delivery State' => :delivery_state,
      'Delivery City' => :delivery_city,
      'Delivery Email' => :delivery_email,
      'Pcs' => :pcs,
      'Product Order Value (ex VAT)' => :product_order_value_ex_vat,
      'Shipping Value (ex VAT)' => :shipping_value_ex_vat,
      'Voucher Value (ex VAT)' => :voucher_value_ex_vat,
      'Total Order Value (ex VAT)' => :total_order_value_ex_vat,
      'VAT Deduct' => :vat_deduct,
      'VAT' => :vat,
      'Total Order Value (inc VAT)' => :total_order_value_inc_vat,
      'Refunded' => :refunded,
      'Currency' => :currency,
      'Currency Rate' => :currency_rate,
      'Total Order Value (SEK)' => :total_order_value_sek,
      'VAT (SEK)' => :vat_sek,
      'Shipping Value (ex VAT) (SEK)' => :shipping_value_ex_vat_sek,
      'Voucher Value (ex VAT) (SEK)' => :voucher_value_ex_vat_sek,
      'Affiliate' => :affiliate,
      'EC Vat' => :ec_vat,
      'VAT#' => :'vat#',
      'Collection' => :collection,
    }.freeze

    def self.call(header)
      MAP.fetch(header) do
        warn "[CENTRA] Unmapped key: #{header}"
        HoneyFormat::ConvertHeaderValue.call(header)
      end
    end
  end
end
