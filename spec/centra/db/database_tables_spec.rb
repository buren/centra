# frozen_string_literal: true

require "spec_helper"

require "centra/db/database_tables"

RSpec.describe Centra::DatabaseTables do
  describe "#merge!" do
    it "can merge with hash" do
      tables = described_class.new
      tables["orders"] = "my_orders"
      expect(tables[:orders]).to eq("my_orders")
      expect(tables[:products]).to eq("centra_products")
    end
  end

  describe "#[]" do
    it "returns value for key as symbol" do
      tables = described_class.new
      expect(tables[:orders]).to eq("centra_orders")
    end

    it "returns value for key as string" do
      tables = described_class.new
      expect(tables["orders"]).to eq("centra_orders")
    end

    it "raises KeyError for unknown key" do
      tables = described_class.new
      expect { tables[:wat] }.to raise_error(KeyError)
    end
  end

  describe "#[]=" do
    it "sets value for key" do
      tables = described_class.new
      tables[:orders] = "my_orders"
      expect(tables[:orders]).to eq("my_orders")
    end

    it "raises KeyError for unknown key" do
      tables = described_class.new
      expect { tables[:wat] = "1" }.to raise_error(KeyError)
    end

    it "raises TypeError for invalid value type" do
      tables = described_class.new
      expect { tables[:orders] = 1 }.to raise_error(TypeError)
    end
  end
end
