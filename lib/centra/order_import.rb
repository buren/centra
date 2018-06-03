# frozen_string_literal: true

module Centra
  class OrderImport
    def self.call(db_connection, orders)
      sql = <<~SQL
      COPY  orders(
        order_id,
        order_date,
        paytype
      ) FROM STDIN CSV DELIMITER ','
      SQL

      db_connection.copy_data(sql) do |conn|
        orders.each do |order|
          conn.put_copy_data order.to_csv
        end
      end
    end
  end
end
