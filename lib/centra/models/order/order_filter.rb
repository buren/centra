# frozen_string_literal: true

module Centra
  class OrderFilter < ModelFilter
    def initialize(countries: [], date_range: nil)
      super(
        fields: { country: :delivery_country, datetime: :order_date },
        countries: countries,
        date_range: date_range,
      )
    end
  end
end
