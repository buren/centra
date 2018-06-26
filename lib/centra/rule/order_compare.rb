# frozen_string_literal: true

module Centra
  module Rule
    class OrderCompare
      def self.allowed_delay_in_minutes
        @allowed_delay_in_minutes ||= 90.0
      end

      def self.allowed_delay_in_minutes=(mins) # rubocop:disable Style/TrivialAccessors
        @allowed_delay_in_minutes = mins
      end

      include Comparable

      attr_reader :order

      def initialize(order, allowed_delay_in_minutes: self.class.allowed_delay_in_minutes)
        @order = order
        @allowed_delay_in_minutes = allowed_delay_in_minutes
      end

      def ==(other)
        return false if order.email != other.email
        return false if order.delay_in_seconds(other) > allowed_delay_in_seconds

        true
      end

      def allowed_delay_in_seconds
        60 * @allowed_delay_in_minutes
      end
    end
  end
end
