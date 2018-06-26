# frozen_string_literal: true

require "centra/db/connection"
require "centra/db/import/csv_import"

module Centra
  module DB
    class OrderImport
      def self.call(orders, connection: Connection.new, table_name: Centra.config.database.table_names[:orders])
        CSVImport.call(orders, table_name, connection)
      end
    end
  end
end
