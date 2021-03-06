# frozen_string_literal: true

require "spec_helper"

RSpec.describe Centra::OrderCSV do
  describe "#header" do
    it "can return first column" do
      csv_string = File.read("spec/data/10_orders.csv")
      data = Centra::OrderCSV.new(csv_string)

      expect(data.header.first).to eq(:order_id)
    end

    it "can return column with 'difficult' name" do
      csv_string = File.read("spec/data/10_orders.csv")
      data = Centra::OrderCSV.new(csv_string)

      expect(data.header).to include(:shipping_value_ex_vat_sek)
    end
  end

  describe "#rows" do
    it "can return the first row" do
      csv_string = File.read("spec/data/10_orders.csv")
      data = Centra::OrderCSV.new(csv_string, anonymize: false)

      order = data.rows.first

      expect(order.order_date.to_date).to eq(Date.new(2013, 3, 25))
      expect(order.paytype).to eq("None")
      expect(order.email).to eq("1908483cb653@example.com")
    end

    it "can skip anonymization" do
      csv_string = File.read("spec/data/10_orders.csv")
      data = Centra::OrderCSV.new(csv_string, anonymize: false)

      order = data.rows.first
      expect(order.email).to eq("1908483cb653@example.com")
    end

    it "can anonymize" do
      csv_string = File.read("spec/data/10_orders.csv")
      data = Centra::OrderCSV.new(csv_string, anonymize: true)

      order = data.rows.first
      expect(order.email).not_to eq("1908483cb653@example.com")
    end
  end
end
