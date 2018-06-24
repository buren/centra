require "spec_helper"

RSpec.describe Centra::AnonStore do
  describe "::build" do
    it "returns an instance of store" do
      expect(described_class.build).to be_a(described_class)
    end
  end

  describe "#value_for" do
    it "consistently anonymize the same value" do
      store = described_class.new

      email = "joe@example.com"
      value = store.value_for(email)
      value1 = store.value_for(email)

      expect(value).to eq(value1)
    end

    it "does not consistently anonymize the same value across store initializations" do
      store = described_class.new
      store1 = described_class.new

      email = "joe@example.com"
      value = store.value_for(email)
      value1 = store1.value_for(email)

      expect(value).not_to eq(value1)
    end
  end
end
