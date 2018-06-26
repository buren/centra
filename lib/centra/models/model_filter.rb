module Centra
  class ModelFilter
    def initialize(fields: {}, countries: [], date_range: nil)
      @fields = fields
      @date_range = date_range
      @countries = countries
    end

    def allow?(model)
      return false unless date_range_covered?(model)
      return false unless included_country?(model)

      true
    end

    def date_range_covered?(model)
      return true unless @date_range

      @date_range.cover?(datetime(model))
    end

    def included_country?(model)
      return true if @countries.empty?

      @countries.include?(country(model))
    end

    private

    def datetime(model)
      model.public_send(@fields.fetch(:datetime))
    end

    def country(model)
      model.public_send(@fields.fetch(:country))
    end
  end
end
