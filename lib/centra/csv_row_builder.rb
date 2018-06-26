# frozen_string_literal: true

module Centra
  class CSVRowBuilder
    def initialize(anonymize: true)
      @store = Centra.config.anon_store.build
      @anonymize = anonymize
    end

    def call(row)
      anonymize!(row) if @anonymize
      row_klass.new(row)
    end

    # remove potentially sensitive data
    def anonymize!(row)
      # NOTE: Should be implemented in subclass
    end

    def row_klass
      raise(NotImplementedError, 'you must implement this in subclass')
    end

    private

    def anon_value_for(value, &block)
      @store.value_for(value, &block)
    end
  end
end
