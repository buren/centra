# frozen_string_literal: true

require 'digest'

module Centra
  # Consistently anonymize a value between initializations
  class ConsistentAnonStore
    def self.build
      new
    end

    def value_for(value)
      return if value.nil?
      return value if value.respond_to?(:empty?) && value.empty?

      Digest::MD5.hexdigest(value)
    end
  end
end
