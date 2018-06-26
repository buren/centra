require "time"

require "centra/version"
require "centra/configuration"
require "centra/helpers/null_logger"
require "centra/helpers/loggable"

# Stores
require "centra/helpers/anon_store"
require "centra/helpers/consistent_anon_store"

require "centra/csv_header_converter"
require "centra/helpers/date_range"
require "centra/models"
require "centra/rule"

module Centra
  HoneyFormat.configure do |config|
    # TODO: Find another way of handling invalid/blank timestamps,
    #       currently we need this since PostgreSQL doesn't accept CSV imports
    #       with blank date fields.
    # NOTE: PostgreSQL COPY command chokes on empty timestamps
    config.converter.register(
      :datetime_or_unix_epoch,
      ->(v) { config.converter[:datetime].call(v) || Time.new(1979, 1, 1) }
    )
  end

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
