module Centra
  class Order
    def initialize(data)
      @data = data
    end

    def id
      @data.order_id
    end

    # TODO: Transform columns - until PostgreSQL accepts the CSV-import
    #   i.e
    #     - numeric values can be missing / represented as empty strings

    def email
      @email ||= @data.delivery_email.strip.downcase
    end

    def order_date
      @order_date ||= safe_to_datetime(@data.order_date)
    end

    def captured_date
      @captured_date ||= safe_to_datetime(@data.captured_date)
    end

    def pcs
      # The Centra export sometimes outputs this value as a float (1.0 etc..)
      # so we need to first parse it as a float and then convert it to an integer
      @pcs ||= safe_to_i(@data.pcs)
    end

    def total_order_value_sek
      @total_order_value_sek ||= safe_to_f(@data.total_order_value_sek)
    end

    def vat_deduct
      safe_to_f(@data.vat_deduct)
    end

    def captured
      safe_to_f(@data.captured)
    end

    def product_order_value_ex_vat
      safe_to_f(@data.product_order_value_ex_vat)
    end

    def shipping_value_ex_vat
      safe_to_f(@data.shipping_value_ex_vat)
    end

    def voucher_value_ex_vat
      safe_to_f(@data.voucher_value_ex_vat)
    end

    def total_order_value_ex_vat
      safe_to_f(@data.total_order_value_ex_vat)
    end

    def vat
      safe_to_f(@data.vat)
    end

    def total_order_value_inc_vat
      safe_to_f(@data.total_order_value_inc_vat)
    end

    def refunded
      safe_to_f(@data.refunded)
    end

    def currency_rate
      safe_to_f(@data.currency_rate)
    end

    def vat_sek
      safe_to_f(@data.vat_sek)
    end

    def shipping_value_ex_vat_sek
      safe_to_f(@data.shipping_value_ex_vat_sek)
    end

    def voucher_value_ex_vat_sek
      safe_to_f(@data.voucher_value_ex_vat_sek)
    end

    def delay_in_minutes(other)
      delay_in_seconds(other) / 60.0
    end

    def delay_in_seconds(other)
      (order_date - other.order_date).abs
    end

    def method_missing(method, *args, &block)
      super unless respond_to_missing?(method)

      @data.public_send(method, *args, &block)
    end

    def respond_to_missing?(meth, include_private = false)
      @data.respond_to?(meth)
    end

    def inspect
      "#<Order:#{"0x00%x" % (object_id << 1)}(email: #{@email}, order_date: #{@order_date})"
    end

    def to_csv
      row = members.map do |column_name|
        column = public_send(column_name)
        if column.respond_to?(:to_csv)
          column.to_csv
        else
          column.to_s
        end
      end

      CSV.generate_line(row)
    end

    # @return [Array<Symbol>] list of order attribute names
    def members
      @data.members
    end

    private

    def safe_to_f(value)
      return 0.0 unless value
      Float(value)
    rescue ArgumentError
      0.0
    end

    def safe_to_i(value)
      return 0 unless value
      # integer can sometimes be formatted as floats "1.0" in the Centra export
      float_value = safe_to_f(value)
      return 0 unless float_value

      value.to_i
    rescue ArgumentError
      0
    end

    def safe_to_datetime(value)
      # some date fields can be formatted as "0000:00:00 00:00"
      # TODO: Make sure to use the same time zone as Centra
      # NOTE: Seems like Centra can have different settings for this depending on the
      #       server, so we should probably allow the user to configure this
      Time.parse(value)
    rescue ArgumentError
      # TODO: Find another way of handling invalid/blank timestamps,
      #       currently we need this since PostgreSQL doesn't accept CSV imports
      #       with blank date fields.
      Time.new(1979, 1, 1) # psql \copy command chokes on empty timestamps
    end
  end
end
