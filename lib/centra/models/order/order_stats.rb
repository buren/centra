# frozen_string_literal: true

require "set"
require "time"

module Centra
  class OrderStats
    def self.calculate(centra_data)
      new(centra_data).calculate
    end

    attr_reader :result, :order_filter

    def initialize(orders)
      @orders = orders
      @result = nil
    end

    def calculate
      return self if @result

      orders_per_email = Hash.new(0)
      currencies = Set.new
      payment_method_codes = Set.new
      billing_countries = Set.new
      total_revenue = 0
      total_pcs = 0
      first_order_date = Time.new(3000, 1, 1)
      last_order_date = Time.new(1, 1, 1)
      total_orders_in_stats = 0

      @orders.each do |order|
        total_orders_in_stats += 1

        email = order.delivery_email
        orders_per_email[email] += 1

        currencies << order.currency
        payment_method_codes << order.payment_method_code
        billing_countries << order.billing_country

        order_date = order.order_date
        first_order_date = order_date if first_order_date > order_date
        last_order_date = order_date if last_order_date < order_date

        total_revenue += order.total_order_value_sek
        total_pcs += order.pcs
      end

      total_orders = @orders.all.length
      total_unique_emails = orders_per_email.keys.length
      total_currencies = currencies.length

      avg_order_value = total_revenue / total_orders.to_f
      avg_orders_per_email = total_orders / total_unique_emails.to_f

      @result = {
        orders_per_email: orders_per_email,
        currencies: currencies,
        payment_method_codes: payment_method_codes,
        billing_countries: billing_countries,

        first_order_date: first_order_date,
        last_order_date: last_order_date,

        total_revenue: total_revenue,
        total_pcs: total_pcs,
        total_orders: total_orders,
        total_orders_in_stats: total_orders_in_stats,
        total_unique_emails: total_unique_emails,
        total_currencies: total_currencies,

        avg_order_value: avg_order_value,
        avg_value_per_email: total_revenue / total_unique_emails.to_f,
        avg_orders_per_email: avg_orders_per_email,
        avg_pcs_per_order: total_pcs / total_orders.to_f,

        purchase_frequency: avg_orders_per_email,
        customer_value: avg_order_value * avg_orders_per_email
      }
      self
    end
  end
end
