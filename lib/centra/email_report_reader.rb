# frozen_string_literal: true

require "uri"

module Centra
  class EmailReportReader
    attr_reader :email_body

    def initialize(email_body, hostname: nil)
      @hostname = hostname
      @email_body = email_body
      @urls = nil
    end

    def absolute_urls
      @urls ||= URI.extract(email_body, %w(http https))
    end

    # @return [URI] the report URI
    def report_uri
      # The first URL in the email is the report file
      first_url = absolute_urls.first
      return URI.parse(first_url) if first_url

      # Unfortunately Centra has a bug where only the path to the
      # report file is present and not a full absolute URL
      # therefore we need to parse it out ourselves
      report_path_matcher = /\/[\S]+\/export\?file\=[\S]+.(csv|xls)/
      url_path = email_body.match(report_path_matcher).to_s

      URI(url_path).tap do |uri|
        next unless @hostname
        uri.scheme = "https"
        uri.hostname = @hostname
      end
    end
  end
end
