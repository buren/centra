# frozen_string_literal: true

require 'spec_helper'

require 'centra/db/migrations/create_products'

RSpec.describe Centra::Migrations::CreateProducts do
  let(:mock_connection) do
    Class.new do
      attr_reader :last_sql
      define_method(:execute) { |sql| @last_sql = sql }
    end.new
  end

  describe '#up' do
    it 'has CREATE TABLE products' do
      executed_sql = described_class.new(mock_connection).up
      expect(executed_sql).to include('CREATE TABLE products')
    end
  end

  describe '#down' do
    it 'drops products table' do
      executed_sql = described_class.new(mock_connection).down
      expect(executed_sql.strip).to eq('DROP TABLE products;')
    end
  end
end
