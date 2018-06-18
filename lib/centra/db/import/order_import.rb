# frozen_string_literal: true

module Centra
  module DB
    class OrderImport
      def self.call(connection, orders, table_name: Centra.config.database.table_names[:orders])
        sql = <<~SQL
          COPY #{table_name}(#{orders.columns.join(',')})
          FROM STDIN CSV DELIMITER ','
        SQL

        connection.copy_data(sql) do |conn|
          orders.each { |order| conn.put_copy_data(order.to_csv) }
        end
      end
    end
  end
end
