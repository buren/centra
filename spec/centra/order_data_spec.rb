require 'spec_helper'

RSpec.describe Centra::OrderData do
  describe '#header' do
    it 'can return first column' do
      csv_string = File.read('spec/data/1-orders.csv')
      data = Centra::OrderData.new(csv_string)

      expect(data.header.first).to eq('Order')
    end
  end

  describe '#rows' do
    it 'can return the first row' do
      csv_string = File.read('spec/data/1-orders.csv')
      data = Centra::OrderData.new(csv_string)

      order = data.rows.first
      expect(order).to eq('Order')
    end
  end
end
