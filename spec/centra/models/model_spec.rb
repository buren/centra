# frozen_string_literal: true

require "spec_helper"

RSpec.describe Centra::Model do
  context "with overriden methods" do
    it "returns overriden method value or delegates" do
      data = Struct.new(:name, :city).new("buren", "stockholm")
      model = Class.new(described_class) do
        define_method(:name) { "jacob" }
      end.new(data)

      expect(model.name).to eq("jacob")
      expect(model.city).to eq("stockholm")
    end
  end

  describe "#to_csv" do
    it "returns model as CSV string" do
      data = Struct.new(:name, :city).new("buren", "stockholm")
      model = described_class.new(data)

      expect(model.to_csv).to eq("buren,stockholm\n")
    end

    context "with overriden methods" do
      it "returns model as CSV string" do
        data = Struct.new(:name, :city).new("buren", "stockholm")
        model = Class.new(described_class) do
          define_method(:name) { "jacob" }
        end.new(data)

        expect(model.to_csv).to eq("jacob,stockholm\n")
      end
    end
  end

  describe "#members" do
    it "returns all row attributes" do
      data = Struct.new(:name, :city).new("buren", "stockholm")
      model = described_class.new(data)

      expect(model.members).to eq(%i[name city])
    end
  end
end
