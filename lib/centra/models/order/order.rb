# frozen_string_literal: true

module Centra
  class Order < Model
    def id
      @data.order_id
    end

    def email
      @email ||= @data.delivery_email.strip.downcase
    end

    # Convinence method for Rule order matching
    def delay_in_minutes(other)
      delay_in_seconds(other) / 60.0
    end

    # Convinence method for Rule order matching
    def delay_in_seconds(other)
      (order_date - other.order_date).abs
    end
  end
end
