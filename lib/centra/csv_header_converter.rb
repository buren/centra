# frozen_string_literal: true

module Centra
  class CSVHeaderConverter
    def initialize(map)
      @map = map
    end

    def call(header, index)
      @map.fetch(header) do
        warn "[CENTRA] Unmapped key: #{header}"
        HoneyFormat::ConvertHeaderValue.call(header, index)
      end
    end
  end
end
