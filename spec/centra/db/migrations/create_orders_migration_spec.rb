# frozen_string_literal: true

require 'spec_helper'

require 'centra/db/migrations/create_orders'

RSpec.describe Centra::Migrations::CreateOrders do
  let(:mock_connection) do
    Class.new do
      attr_reader :last_sql
      define_method(:execute) { |sql| @last_sql = sql }
    end.new
  end

  describe '#up' do
    it 'has CREATE TABLE orders' do
      executed_sql = described_class.new(mock_connection).up
      expect(executed_sql).to include('CREATE TABLE orders')
    end
  end

  describe '#down' do
    it 'drops orders table' do
      executed_sql = described_class.new(mock_connection).down
      expect(executed_sql.strip).to eq('DROP TABLE orders;')
    end
  end
end
