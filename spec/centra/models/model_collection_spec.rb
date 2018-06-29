# frozen_string_literal: true

require "spec_helper"

RSpec.describe Centra::ModelCollection do
  let(:stockholm_filter) do
    Class.new do
      def allow?(record)
        record.city == 'stockholm'
      end
    end.new
  end

  describe described_class::AllowFilter do
    describe "#allow?" do
      it "returns true" do
        filter = described_class.new
        expect(filter.allow?(nil)).to eq(true)
      end
    end
  end

  describe "#columns" do
    it "returns the columns" do
      matrix = HoneyFormat::Matrix.new(
        [
          %w[name city],
          %w[buren stockholm]
        ]
      )
      collection = described_class.new(matrix)

      expect(collection.columns).to eq(%i[name city])
    end
  end

  describe "#all" do
    it "returns all rows" do
      matrix = HoneyFormat::Matrix.new(
        [
          %w[name city],
          %w[buren stockholm],
          %w[jacob malmo],
        ]
      )
      collection = described_class.new(matrix, stockholm_filter)

      expect(collection.all.length).to eq(2)
    end
  end

  describe "#filtered" do
    it "returns filtered rows" do
      matrix = HoneyFormat::Matrix.new(
        [
          %w[name city],
          %w[buren stockholm],
          %w[jacob malmo],
        ]
      )
      collection = described_class.new(matrix, stockholm_filter)

      expect(collection.filtered.length).to eq(1)
    end
  end

  describe "#each" do
    it "yields each, filtered, row" do
      matrix = HoneyFormat::Matrix.new(
        [
          %w[name city],
          %w[buren stockholm],
          %w[jacob malmo],
          %w[peter malmo],
        ]
      )
      collection = described_class.new(matrix, stockholm_filter)

      collection.each do |model|
        expect(model.city).to eq('stockholm')
      end
    end
  end
end
