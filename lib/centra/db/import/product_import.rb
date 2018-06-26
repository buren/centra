# frozen_string_literal: true

require "centra/db/connection"
require "centra/db/import/csv_import"

module Centra
  module DB
    class ProductImport
      def self.call(products, connection: Connection.new, table_name: Centra.config.database.table_names[:products])
        CSVImport.call(products, table_name, connection)
      end
    end
  end
end
