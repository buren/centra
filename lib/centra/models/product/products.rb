# frozen_string_literal: true

module Centra
  class Products
    include Enumerable

    def initialize(centra_products)
      @products = centra_products
    end

    def columns
      return [] unless @products.any?
      @products.first.members
    end

    def all
      @products.rows
    end

    def each(&block)
      all.each(&block)
    end
  end
end
