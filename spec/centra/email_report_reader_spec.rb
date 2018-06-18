require "spec_helper"

require "centra/email_report_reader"

RSpec.describe Centra::EmailReportReader do
  describe "#report_uri" do
    it "returns the report URL" do
      email_body = <<~EMAIL
      A report was generated. You can view it here
      https://example.com/ams/export?file=91_1c7ea0.csv
      EMAIL

      report_reader = described_class.new(email_body)

      expected = "https://example.com/ams/export?file=91_1c7ea0.csv"
      expect(report_reader.report_uri.to_s).to eq(expected)
    end
  end
end
