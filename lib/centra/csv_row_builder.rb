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
      row.order = anon_value_for(row.order)
      row.payment_reference = anon_value_for(row.payment_reference)

      # TODO: Check if the below values are present in the CSV
      # (depending on the type of export they might not..)
      # and only anonymize the present values

      # anonymize delivery fields
      # row.billing_name = anon_value_for(row.billing_name)
      # row.billing_company = anon_value_for(row.billing_company)
      # row.billing_address = anon_value_for(row.billing_address)
      # row.billing_coaddress = anon_value_for(row.billing_coaddress)
      # row.billing_zipcode = anon_value_for(row.billing_zipcode)
      # # anonymize delivery fields
      # row.delivery_email = anon_email_for(row.delivery_email)
      # row.delivery_name = anon_value_for(row.delivery_name)
      # row.delivery_company = anon_value_for(row.delivery_company)
      # row.delivery_address = anon_value_for(row.delivery_address)
      #
      # row.delivery_coaddress = anon_value_for(row.delivery_coaddress)
      # row.delivery_zipcode = anon_value_for(row.delivery_zipcode)
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
