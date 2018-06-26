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

    def respond_to_missing?(meth, include_private = false)
      @data.respond_to?(meth)
    end

    protected

    def safe_to_f(value)
      return 0.0 unless value
      Float(value)
    rescue ArgumentError
      0.0
    end

    def safe_to_i(value)
      return 0 unless value
      # integer can sometimes be formatted as floats "1.0" in the Centra export
      float_value = safe_to_f(value)
      return 0 unless float_value

      value.to_i
    rescue ArgumentError
      0
    end

    def safe_to_datetime(value)
      # some date fields can be formatted as "0000:00:00 00:00"
      # TODO: Make sure to use the same time zone as Centra
      # NOTE: Seems like Centra can have different settings for this depending on the
      #       server, so we should probably allow the user to configure this
      Time.parse(value)
    rescue ArgumentError
      # TODO: Find another way of handling invalid/blank timestamps,
      #       currently we need this since PostgreSQL doesn't accept CSV imports
      #       with blank date fields.
      Time.new(1979, 1, 1) # psql \copy command chokes on empty timestamps
    end
  end
end
