# frozen_string_literal: true

require "spec_helper"

RSpec.describe Centra::Order do
  describe "#members" do
    it "returns list of attributes" do
      data = Struct.new(:field1, :field2).new("1", "1")
      order = Centra::Order.new(data)

      expect(order.members).to eq(%i(field1 field2))
    end
  end
end
