# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Centra::Order do
  describe '#captured_date' do
    it 'returns nil if data has 0000-00-00 00:00:00 as value' do
      data = Struct.new(:captured_date).new('0000-00-00 00:00:00')
      order = Centra::Order.new(data)

      expect(order.captured_date).to be_nil
    end
  end

  %i[
    pcs
    product_order_value_ex_vat
    shipping_value_ex_vat
    voucher_value_ex_vat
    total_order_value_ex_vat
    vat_deduct
    vat
    total_order_value_inc_vat
    refunded
    currency_rate
    total_order_value_sek
    vat_sek
    shipping_value_ex_vat_sek
    voucher_value_ex_vat_sek
  ].each do |field|
    describe "##{field}" do
      it 'returns correct value when value is nil' do
        data = Struct.new(field).new(nil)
        order = Centra::Order.new(data)

        expect(order.public_send(field)).to be_nil
      end
    end
  end
end
