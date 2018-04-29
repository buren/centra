module Centra
  class OrderFilter
    def initialize(countries: [], date_range: nil)
      @date_range = date_range
      @countries = countries
    end

    def allow?(order)
      return false unless @date_range.cover?(order.order_date)
      return false unless included_country?(order.delivery_country)

      true
    end

    def included_country?(country)
      return true if @countries.empty?

      @countries.include?(country)
    end
  end
end
