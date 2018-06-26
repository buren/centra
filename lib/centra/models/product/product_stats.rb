# frozen_string_literal: true

require "set"
require "time"

module Centra
  class ProductStats
    def self.calculate(centra_data)
      new(centra_data).calculate
    end

    attr_reader :result, :product_filter

    def initialize(products)
      @products = products
      @result = nil
    end

    def calculate
      return self if @result

      products_per_email = Hash.new(0)
      currencies = Set.new
      countries = Set.new
      product_names = Set.new
      skus = Set.new
      variants = Set.new
      folders = Set.new
      sizes = Set.new
      brands = Set.new
      orders = Set.new
      total_revenue = 0
      total_product_cost = 0
      total_pcs = 0
      first_product_date = Time.new(3000, 1, 1)
      last_product_date = Time.new(1, 1, 1)
      total_products_in_stats = 0

      @products.each do |product|
        total_products_in_stats += 1
        products_per_email[product.email] += 1

        currencies << product.currency
        countries << product.country
        product_names << product.product_name
        skus << product.sku
        variants << product.variant
        folders << product.folder
        sizes << product.size
        brands << product.brand
        orders << product.order_id

        product_date = product.created_at
        first_product_date = product_date if first_product_date > product_date
        last_product_date = product_date if last_product_date < product_date

        total_product_cost += product.total
        total_revenue += product.total * product.quantity
        total_pcs += product.quantity
      end

      total_order_products = @products.all.length
      total_unique_emails = products_per_email.keys.length
      total_currencies = currencies.length

      avg_order_product_value = total_revenue / total_order_products.to_f
      avg_product_value = total_product_cost / total_order_products.to_f

      @result = {
        products_per_email: products_per_email,
        currencies: currencies,
        countries: countries,
        product_names: product_names,
        skus: skus,
        variants: variants,
        folders: folders,
        sizes: sizes,
        brands: brands,
        orders: orders,

        first_product_date: first_product_date,
        last_product_date: last_product_date,

        total_product_cost: total_product_cost,
        total_revenue: total_revenue,
        total_pcs: total_pcs,
        total_order_products: total_order_products,
        total_products_in_stats: total_products_in_stats,
        total_unique_emails: total_unique_emails,
        total_currencies: total_currencies,

        avg_product_value: avg_product_value,
        avg_order_product_value: avg_order_product_value,
        avg_value_per_email: total_revenue / total_unique_emails.to_f,
        avg_pcs_per_order_product: total_pcs / total_order_products.to_f,
      }
      self
    end
  end
end
