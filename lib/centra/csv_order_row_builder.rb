# frozen_string_literal: true

module Centra
  class CSVOrderRowBuilder
    def initialize(anonymize: true)
      @store = Centra.config.anon_store.build
      @anonymize = anonymize
    end

    def call(row)
      anonymize!(row) if @anonymize
      Order.new(row)
    end

    def anonymize!(row)
      # remove potentially sensitive IDs
      row.payment_reference = anon_value_for(row.payment_reference)
      row.delivery_email = anon_value_for(row.delivery_email)

      %i[
        billing_name
        billing_company
        billing_address
        billing_coaddress
        billing_zipcode
        delivery_name
        delivery_company
        delivery_address
        delivery_coaddress
        delivery_zipcode
      ].each do |field|
        # These field values might not be included in the CSV-export
        # so we need to check if they're present first
        next unless row.respond_to?(field)

        row[field] = anon_value_for(row[field])
      end
    end

    private

    def anon_value_for(value, &block)
      @store.value_for(value, &block)
    end
  end
end
