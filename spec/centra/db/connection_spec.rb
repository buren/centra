# frozen_string_literal: true

require "spec_helper"
require "centra/db/connection"

RSpec.describe Centra::DB::Connection do
  describe "initialize options" do
    it "raises ArgumentError if required keywords are missing" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it "can initialize with config & options" do
      Centra.configure do |config|
        config.database.dbname = "configname"
      end

      connection = described_class.new(
        host: "host",
        user: "user",
        password: "pass"
      )
      expect(connection.options[:dbname]).to eq("configname")
    end

    it "can initialize with valid options" do
      connection = described_class.new(
        dbname: "name",
        host: "host",
        user: "user",
        password: "pass"
      )

      expected = {
        dbname: "name",
        host: "host",
        port: 5432,
        user: "user",
        password: "pass",
        connect_timeout: 15
      }
      expect(connection.options).to eq(expected)
    end
  end
end
