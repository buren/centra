# frozen_string_literal: true

module Centra
  class OrderFilter
    def initialize(countries: [], date_range: nil)
      @date_range = date_range
      @countries = countries
    end

    def allow?(order)
      return false unless date_range_covered?(order)
      return false unless included_country?(order)

      true
    end

    def date_range_covered?(order)
      return true unless @date_range

      @date_range.cover?(order.order_date)
    end

    def included_country?(order)
      return true if @countries.empty?

      @countries.include?(order.delivery_country)
    end
  end
end
