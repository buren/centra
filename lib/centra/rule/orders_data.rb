require "centra/order"

module Centra
  module Rule
    # Build order data
    class OrdersData
      attr_reader :centra_orders, :rule_orders

      def initialize(centra_csv, rule_csv, date_range, countries)
        @date_range = date_range
        @countries = countries

        @email_orders = Hash.new do |hash, key|
          hash[key] = { centra: [], rule: [] }
        end

        @centra_orders = build_centra_orders!(centra_csv.rows)
        @rule_orders = build_rule_orders!(rule_csv.rows)
      end

      # @return [Hash]
      # @example Return example
      #   data.email_orders
      #   # => { "jane@example.com" => { centra: [#<Object:0x007f>], rule: [#<Object:0x009d>] } }
      def email_orders
        @email_orders
      end

      private

      def build_centra_orders!(rows)
        orders = []
        rows.each do |row|
          order = Order.new(row)
          next if excluded_country?(order.delivery_country)
          next unless @date_range.cover?(order.order_date)

          @email_orders[order.email][:centra] << order
          orders << order
        end
        orders
      end

      def build_rule_orders!(rows)
        orders = []
        rows.each do |row|
          order = Order.new(row)
          next unless @date_range.cover?(order.order_date)

          @email_orders[order.email][:rule] << order
          orders << order
        end
        orders
      end

      def excluded_country?(country)
        return true unless country

        @countries.any? && !@countries.include?(country)
      end
    end
  end
end
