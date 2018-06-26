# frozen_string_literal: true

module Centra
  module Rule
    class OrderCalculator
      def initialize(order_matcher)
        @order_matcher = order_matcher

        @email_orders = nil
        @centra_orders = nil
        @email_delays = nil
        @average_delay = nil
      end

      def missing
        @order_matcher.missing
      end

      def matched
        @order_matcher.matched
      end

      def email_orders
        @email_orders ||= @order_matcher.data.email_orders
      end

      def centra_orders
        @centra_orders ||= @order_matcher.data.centra_orders
      end

      def miss_percentage
        (missing.length.to_f / centra_orders.length) * 100
      end

      def email_delays
        @email_delays ||= matched.map do |match|
          match[:centra].delay_in_minutes(match[:rule])
        end
      end

      def total_pcs
        @total_pcs ||= centra_orders.map(&:pcs).sum
      end

      def total_order_value_mkr_sek
        @total_order_value_mkr_sek ||= begin
          centra_orders.map(&:total_order_value_sek).sum / 1_000_000
        end
      end

      def missing_total_order_value_mkr_sek
        @missing_total_order_value_mkr_sek ||= begin
          missing.map(&:total_order_value_sek).sum / 1_000_000
        end
      end

      def average_delay
        @average_delay ||= email_delays.sum.to_f / matched.length
      end

      def average_orders_per_email
        centra_orders.length / email_orders.length.to_f
      end
    end
  end
end
