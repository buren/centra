# frozen_string_literal: true

require 'centra/helpers/anon_store'

module Centra
  class CSVRowBuilder
    def initialize(anonymize: true)
      @store = AnonStore.new
      @anonymize = anonymize
    end

    def call(row)
      anonymize!(row) if @anonymize
      Order.new(row)
    end

    def anonymize!(row)
      # remove potentially sensitive IDs
      row.payment_reference = anon_value_for(row.payment_reference)
      row.delivery_email = anon_email_for(row.delivery_email)

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

        anon_value = anon_value_for(row.public_send(field))
        row.public_send("#{field}=", anon_value)
      end
    end

    private

    def anon_email_for(email)
      anon_value_for(email) { "#{SecureRandom.hex(6)}@example.com" }
    end

    def anon_value_for(value, &block)
      @store.value_for(value, &block)
    end
  end
end
