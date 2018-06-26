# frozen_string_literal: true

module Centra
  DateRange = Struct.new(:start_date, :end_date)

  class DateRange
    def cover?(timestamp)
      return false if start_date && timestamp < start_date
      return false if end_date && timestamp > end_date

      true
    end
  end
end
