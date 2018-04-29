module Centra
  class Order
    @@allowed_delay_in_minutes = 90.0

    def self.allowed_delay_in_minutes
      @@allowed_delay_in_minutes
    end

    def self.allowed_delay_in_minutes=(mins)
      @@allowed_delay_in_minutes = mins
    end

    include Comparable

    attr_reader :email, :timestamp, :payment_method

    def initialize(data)
      @email = data.delivery_email.strip.downcase
      @timestamp = Time.parse(data.order_date)
      @data = data
    end

    def ==(other)
      return false if email != other.email
      return false if delay_in_seconds(other) > allowed_delay_in_seconds

      true
    end

    # FIXME: This will raise NoMethodError for if order is a rule order..
    #       find a better way to handle this...
    def pcs
      Integer(@data.pcs)
    end

    # FIXME: This will raise NoMethodError for if order is a rule order..
    #       find a better way to handle this...
    def total_order_value_sek
      Float(@data.total_order_value_sek)
    end

    def delay_in_minutes(other)
      delay_in_seconds(other) / 60.0
    end

    def delay_in_seconds(other)
      (timestamp - other.timestamp).abs
    end

    def allowed_delay_in_seconds
      60 * self.class.allowed_delay_in_minutes
    end

    def method_missing(method, *args, &block)
      @data.public_send(method, *args, &block)
    end

    def inspect
      "#<Order:#{"0x00%x" % (object_id << 1)}(email: #{@email}, timestamp: #{@timestamp})"
    end
  end
end
