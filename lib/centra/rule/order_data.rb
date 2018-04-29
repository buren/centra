module Centra
  module Rule
    # Build order data
    class OrderData
      attr_reader :centra_orders, :rule_orders, :order_filter

      def initialize(centra_csv, rule_csv, order_filter)
        @order_filter = order_filter

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
          next unless order_filter.allow?(order)

          @email_orders[order.email][:centra] << order
          orders << order
        end
        orders
      end

      def build_rule_orders!(rows)
        orders = []
        rows.each do |row|
          order = Order.new(row)
          next unless order_filter.date_range_covered?(order)

          @email_orders[order.email][:rule] << order
          orders << order
        end
        orders
      end
    end
  end
end
