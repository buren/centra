# frozen_string_literal: true

module Centra
  class Model
    def initialize(data)
      @data = data
    end

    def to_csv
      row = members.map do |column_name|
        column = public_send(column_name)
        if column.respond_to?(:to_csv)
          column.to_csv
        else
          column.to_s
        end
      end

      CSV.generate_line(row)
    end

    # @return [Array<Symbol>] list of order attribute names
    def members
      @data.members
    end

    def method_missing(method, *args, &block)
      super unless respond_to_missing?(method)

      @data.public_send(method, *args, &block)
    end

    def respond_to_missing?(meth, _include_private = false)
      @data.respond_to?(meth)
    end
  end
end
