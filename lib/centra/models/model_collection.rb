# frozen_string_literal: true

module Centra
  class ModelCollection
    include Enumerable

    class AllowFilter
      def allow?(_record)
        true
      end
    end

    def initialize(centra_records, filter = AllowFilter.new)
      @records = centra_records
      @filter = filter
    end

    def columns
      return [] unless @records.any?
      @records.first.members
    end

    def all
      @records.rows
    end

    def filtered
      map { |record| record }
    end

    def each
      all.each do |record|
        next unless @filter.allow?(record)
        yield(record)
      end
    end
  end
end
