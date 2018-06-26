require "centra/model"

module Centra
  class Product < Model
    def newsletter
      @data.newsletter == 'Y'
    end
    alias_method :newsletter?, :newsletter

    # TODO: Convert #country to country code

    def created_at
      @created_at ||= safe_to_datetime(@data.created_at)
    end

    def quantity
      @quantity ||= safe_to_i(@data.quantity)
    end

    def total
      @total ||= safe_to_f(@data.total)
    end

    def total_vat
      @total_vat ||= safe_to_f(@data.total_vat)
    end

    def base_total
      @base_total ||= safe_to_f(@data.base_total)
    end

    def base_total_vat
      @base_total_vat ||= safe_to_f(@data.base_total_vat)
    end
  end
end
