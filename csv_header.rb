# CSV-header

class CSVHeader
  HEADER_MAP = {
    email: 'Delivery Email',
    total_order_value_sek: 'Total Order Value (SEK)',
    order: 'Order',
    order_date: 'Order Date',
    paytype: 'Paytype',
    payment_method_code: 'Payment Method Code',
    payment_reference: 'Payment Reference',
    captured: 'Captured',
    captured_date: 'Captured Date',
    billing_country: 'Billing Country',
    delivery_country: 'Delivery Country',
    delivery_email: 'Delivery Email',
    pcs: 'Pcs',
    'Product Order Value (ex VAT)': 'Product Order Value (ex VAT)',
    'Shipping Value (ex VAT)': 'Shipping Value (ex VAT)',
    'Voucher Value (ex VAT)': 'Voucher Value (ex VAT)',
    'Total Order Value (ex VAT)': 'Total Order Value (ex VAT)',
    vat_deduct: 'VAT Deduct',
    vat: 'VAT',
    'Total Order Value (inc VAT)': 'Total Order Value (inc VAT)',
    refunded: 'Refunded',
    currency: 'Currency',
    currency_rate: 'Currency Rate',
    'Total Order Value (SEK)': 'Total Order Value (SEK)',
    'VAT (SEK)': 'VAT (SEK)',
    'Shipping Value (ex VAT) (SEK)': 'Shipping Value (ex VAT) (SEK)',
    'Voucher Value (ex VAT) (SEK)': 'Voucher Value (ex VAT) (SEK)',
    affiliate: 'Affiliate',
    ec_vat: 'EC Vat',
    'vat#': 'VAT#',
    collection: 'Collection',
  }.freeze

  attr_reader :columns

  def initialize(columns)
    @columns = columns
    @header_cache = {}
  end

  def find_index(field)
    return @header_cache[field] if @header_cache[field]

    columns.each_with_index do |column, index|
      if column == HEADER_MAP.fetch(field, field)
        @header_cache[field] = index
        return index
      end
    end

    raise(ArgumentError, "no header column found for '#{field}'")
  end
end
