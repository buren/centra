require "centra/version"
require "centra/configuration"
require "centra/helpers/null_logger"
require "centra/helpers/loggable"

# Stores
require "centra/helpers/anon_store"
require "centra/helpers/consistent_anon_store"

require "centra/csv_header_converter"
require "centra/helpers/date_range"
require "centra/order"
require "centra/orders"
require "centra/order_csv"
require "centra/order_filter"
require "centra/order_stats"

require "centra/product"
require "centra/products"
require "centra/product_csv"

require "centra/rule"

module Centra
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.config
    configuration
  end

  def self.configure
    yield(configuration) if block_given?
    configuration
  end
end
