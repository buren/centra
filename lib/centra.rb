require "centra/version"
require "centra/helpers/null_logger"
require "centra/helpers/loggable"

require "centra/csv_header_converter"
require "centra/helpers/date_range"
require "centra/order"
require "centra/order_csv"
require "centra/order_filter"
require "centra/order_stats"

require "centra/rule"

module Centra
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
    configuration
  end

  class Configuration
    attr_accessor :logger

    def initialize
      @logger = NullLogger.new
    end
  end
end
