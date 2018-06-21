require "spec_helper"

require "centra/email_report_reader"

RSpec.describe Centra::EmailReportReader do
  describe "#report_uri" do
    # file_formats
    %w[csv xls].each do |file_format|
      %w[ams ams72 folder].each do |prefix|
        context "when report URL is absolute" do
          it "returns the report URL" do
            email_body = <<~EMAIL
            A report was generated. You can view it here
            https://example.com/#{prefix}/export?file=91_1c7ea0.#{file_format}
            EMAIL

            report_reader = described_class.new(email_body)

            expected = "https://example.com/#{prefix}/export?file=91_1c7ea0.#{file_format}"
            expect(report_reader.report_uri.to_s).to eq(expected)
          end

          it "returns the report URL and ignores the given hostname" do
            email_body = <<~EMAIL
            A report was generated. You can view it here
            https://example.com/#{prefix}/export?file=91_1c7ea0.#{file_format}
            EMAIL

            report_reader = described_class.new(email_body, hostname: 'store.example.com')

            expected = "https://example.com/#{prefix}/export?file=91_1c7ea0.#{file_format}"
            expect(report_reader.report_uri.to_s).to eq(expected)
          end
        end

        context "when report URL is missing the hostname" do
          it "returns the report URL without hostname if no default is given" do
            email_body = <<~EMAIL
            A report was generated. You can view it here
            /#{prefix}/export?file=91_1c7ea0.#{file_format}
            EMAIL

            report_reader = described_class.new(email_body)

            expected = "/#{prefix}/export?file=91_1c7ea0.#{file_format}"
            expect(report_reader.report_uri.to_s).to eq(expected)
          end

          it "returns the report URL with given default hostname" do
            email_body = <<~EMAIL
            A report was generated. You can view it here
            /#{prefix}/export?file=91_1c7ea0.#{file_format}
            EMAIL

            report_reader = described_class.new(email_body, hostname: 'store.example.com')

            expected = "https://store.example.com/#{prefix}/export?file=91_1c7ea0.#{file_format}"
            expect(report_reader.report_uri.to_s).to eq(expected)
          end
        end

        it "returns an instance of URI" do
          email_body = <<~EMAIL
          A report was generated. You can view it here
          /#{prefix}/export?file=91_1c7ea0.#{file_format}
          EMAIL

          report_reader = described_class.new(email_body)

          expect(report_reader.report_uri).to be_a(URI)
        end
      end
    end
  end
end
