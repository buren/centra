module Centra
  module Rule
    # Match Centra orders with Rule sent emails
    class OrderMatcher
      attr_reader :data

      # @param [OrdersData] orders_data
      # @example Simple example
      # # centra_orders & rule_orders types are Array<Order>
      # data = {
      #   'jane@example.com' => { centra_orders: [], rule_orders: [] }
      # }
      #   MatchOrders.new(data)
      def initialize(orders_data)
        @matched_orders = []
        @missing_order_emails = []
        @data = orders_data

        perform(orders_data.email_orders)
      end

      # @return [Hash] the matched orders
      # @example
      #   order_matcher.matched
      #   # => { rule: #<Order:0x07f..>, centra: #<Order:0x09d..> }
      def matched
        @matched_orders
      end

      # @return [Array<Order>] the Centra order that has no match
      def missing
        @missing_order_emails
      end

      private

      def perform(email_orders)
        email_orders.each do |_email, data|
          data[:centra].each do |centra_order|
            matched_order = nil
            # Try to find a matching rule email
            data[:rule].each do |rule_order|
              if OrderCompare.new(centra_order) == rule_order
                matched_order = { rule: rule_order, centra: centra_order }
                break
              end
            end

            if matched_order
              @matched_orders << matched_order
            else
              @missing_order_emails << centra_order
            end
          end
        end
      end
    end
  end
end
