require "centra/model"

module Centra
  class Order < Model
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

    def inspect
      "#<Order:#{"0x00%x" % (object_id << 1)}(email: #{email}, order_date: #{order_date})"
    end
  end
end
