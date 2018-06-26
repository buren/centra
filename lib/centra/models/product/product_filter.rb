module Centra
  class ProductFilter < ModelFilter
    def initialize(countries: [], date_range: nil)
      super(
        fields: { country: :country, datetime: :created_at },
        countries: countries,
        date_range: date_range,
      )
    end
  end
end
