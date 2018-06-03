# frozen_string_literal: true

module Centra
  class Orders
    include Enumerable

    def initialize(centra_orders, filter = OrderFilter.new)
      @orders = centra_orders
      @filter = filter
    end

    def all
      @orders.rows
    end

    def filtered
      map { |order| order }
    end

    def each(&block)
      all.each do |order|
        next unless @filter.allow?(order)
        yield(order)
      end
    end
  end
end
