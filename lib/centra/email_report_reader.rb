require "uri"

module Centra
  class EmailReportReader
    def initialize(email_body)
      @urls = URI.extract(email_body, %w(http https))
    end

    def report_uri
      URI.parse(@urls.first)
    end
  end
end
