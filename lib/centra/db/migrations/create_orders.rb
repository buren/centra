# frozen_string_literal: true

require "centra/db/migration"

module Centra
  module Migrations
    class CreateOrders < DB::Migration
      # TODO: Figure out what to do with order_id since
      #       duplicates exist in Centras order export
      def up(table_name: Centra.config.database.table_names[:orders])
        log.info "Creating orders table"
        sql = <<~SQL
          CREATE TABLE #{table_name}(
            id SERIAL primary key not null, -- TODO: Consider replacing this with order_id
            -- order_id VARCHAR(20) PRIMARY KEY NOT NULL UNIQUE,
            order_id VARCHAR(20) not null,
            status INT not null DEFAULT 0,
            order_date TIMESTAMP not null,
            paytype VARCHAR(250),
            payment_method_code VARCHAR(250),
            payment_reference VARCHAR(250),
            captured DECIMAL not null DEFAULT 0.0,
            captured_date TIMESTAMP,
            billing_country VARCHAR(30),
            billing_name VARCHAR(250),
            billing_company VARCHAR(250),
            billing_address VARCHAR(250),
            billing_coaddress VARCHAR(250),
            billing_zipcode VARCHAR(250),
            billing_state VARCHAR(250),
            billing_city VARCHAR(250),
            delivery_country VARCHAR(30),
            delivery_name VARCHAR(250),
            delivery_company VARCHAR(250),
            delivery_address VARCHAR(250),
            delivery_coaddress VARCHAR(250),
            delivery_zipcode VARCHAR(250),
            delivery_state VARCHAR(250),
            delivery_city VARCHAR(250),
            delivery_email VARCHAR(250),
            pcs INT not null DEFAULT 0,
            product_order_value_ex_vat DECIMAL not null DEFAULT 0.0,
            shipping_value_ex_vat DECIMAL not null DEFAULT 0.0,
            voucher_value_ex_vat DECIMAL not null DEFAULT 0.0,
            total_order_value_ex_vat DECIMAL not null DEFAULT 0.0,
            vat_deduct DECIMAL not null DEFAULT 0.0,
            vat DECIMAL not null DEFAULT 0.0,
            total_order_value_inc_vat DECIMAL not null DEFAULT 0.0,
            refunded DECIMAL not null DEFAULT 0.0,
            currency VARCHAR(20),
            currency_rate DECIMAL not null DEFAULT 0.0,
            total_order_value_sek DECIMAL not null DEFAULT 0.0,
            vat_sek DECIMAL not null DEFAULT 0.0,
            shipping_value_ex_vat_sek DECIMAL not null DEFAULT 0.0,
            voucher_value_ex_vat_sek DECIMAL not null DEFAULT 0.0,
            affiliate VARCHAR(250),
            ec_vat VARCHAR(250),
            vat_pound VARCHAR(250),
            collection VARCHAR(250)
          );
        SQL
        execute(sql)
      end

      def down(table_name: Centra.config.database.table_names[:orders])
        sql = <<~SQL
          DROP TABLE #{table_name};
        SQL

        log.info "Dropping orders table"
        execute(sql)
      end
    end
  end
end
