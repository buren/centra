# frozen_string_literal: true

require 'centra/db/connection'

module Centra
  module DB
    class CSVImport
      def self.call(records, table_name, connection = Connection.new)
        sql = <<~SQL
          COPY #{table_name}(#{records.columns.join(',')})
          FROM STDIN CSV DELIMITER ','
        SQL

        connection.copy_data(sql) do |conn|
          records.each { |record| conn.put_copy_data(record.to_csv) }
        end
      end
    end
  end
end
