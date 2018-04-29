module Centra
  class Order
    attr_reader :email

    def initialize(data)
      @email = data.delivery_email.strip.downcase
      @data = data
    end

    def order_date
      @order_date ||= Time.parse(@data.order_date)
    end

    def captured_date
      @captured_date ||= Time.parse(@data.captured_date)
    rescue ArgumentError => _e
    end

    def pcs
      Integer(@data.pcs)
    end

    def total_order_value_sek
      Float(@data.total_order_value_sek)
    end

    def delay_in_minutes(other)
      delay_in_seconds(other) / 60.0
    end

    def delay_in_seconds(other)
      (order_date - other.order_date).abs
    end

    def method_missing(method, *args, &block)
      @data.public_send(method, *args, &block)
    end

    def inspect
      "#<Order:#{"0x00%x" % (object_id << 1)}(email: #{@email}, order_date: #{@order_date})"
    end
  end
end