# frozen_string_literal: true

module Centra
  # Consistently anonymize a value
  class AnonStore
    def initialize(length: 12)
      @data = {}
      @length = (length / 2).ceil
    end

    def value_for(value)
      return if value.nil?
      return value if value.respond_to?(:empty?) && value.empty?

      @data.fetch(value) do
        # yield to block if one is given otherwise anonymize it
        @data[value] = block_given? ? yield : SecureRandom.hex(@length)
      end
    end
  end
end
