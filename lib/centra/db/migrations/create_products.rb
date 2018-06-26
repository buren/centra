# frozen_string_literal: true

require "centra/db/migration"

module Centra
  module Migrations
    class CreateProducts < DB::Migration
      def up(table_name: Centra.config.database.table_names[:products])
        log.info "Creating #{table_name} table"

        sql = <<~SQL
          CREATE TABLE #{table_name}(
            id SERIAL primary key not null,
            order_id VARCHAR(20) not null,
            email VARCHAR(250),
            newsletter BOOLEAN not NULL DEFAULT true,
            created_at TIMESTAMP not null,
            country VARCHAR(250),
            brand VARCHAR(250),
            sku VARCHAR(250),
            product_name VARCHAR(250),
            variant VARCHAR(250),
            folder VARCHAR(250),
            size VARCHAR(250),
            quantity INT not null DEFAULT 0,
            total DECIMAL not null DEFAULT 0.0,
            total_vat DECIMAL not null DEFAULT 0.0,
            currency VARCHAR(250),
            base_total DECIMAL not null DEFAULT 0.0,
            base_total_vat DECIMAL not null DEFAULT 0.0,
            base_currency VARCHAR(250)
          );
        SQL
        execute(sql)
      end

      def down(table_name: Centra.config.database.table_names[:products])
        sql = <<~SQL
          DROP TABLE #{table_name};
        SQL

        log.info "Dropping #{table_name} table"
        execute(sql)
      end
    end
  end
end
