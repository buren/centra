module Centra
  class DatabaseTables
    NAMES = {
      orders: :orders,
      products: :products,
    }.map { |k, v| [k.to_s, v.to_s] }.to_h.freeze

    def initialize
      @names = NAMES.dup
    end

    def [](key)
      @names.fetch(key.to_s)
    end

    def []=(key, value)
      key = key.to_s

      unless NAMES.key?(key)
        raise(KeyError, "unknown key '#{key}', known keys are: #{NAMES.keys.inspect}")
      end

      unless [String, Symbol].include?(value.class)
        raise(TypeError, 'value must be a string or a symbol')
      end

      @names[key] = value.to_s
    end

    def merge!(hash)
      hash.each { |key, value| self[key] = value }
      self
    end
  end
end
