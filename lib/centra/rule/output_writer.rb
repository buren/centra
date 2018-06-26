# frozen_string_literal: true

require "csv"

module Centra
  module Rule
    class OutputWriter
      attr_reader :calc

      def self.perform(calculator, csv_path: nil, matched_csv_path: nil)
        new(
          calculator,
          csv_path: csv_path,
          matched_csv_path: matched_csv_path
        ).perform
      end

      def initialize(calculator, csv_path:, matched_csv_path:)
        @calc = calculator
        @stats_summary = nil
        @csv_path = csv_path
        @matched_csv_path = matched_csv_path
      end

      def perform
        stats!
        missing_emails_output!
        matched_orders_output!
      end

      def stats_summary
        @stats_summary ||= <<~STATSOUTPUT
          Total emails          #{calc.email_orders.length}
          Total Centra orders   #{calc.centra_orders.length}
          Allowed delay         #{OrderCompare.allowed_delay_in_minutes} minutes
          Matched orders        #{calc.matched.length}
          Total pcs             #{calc.total_pcs}
          Total order value     #{calc.total_order_value_mkr_sek.round(3)} Mkr
          ---
          Total order value     #{calc.missing_total_order_value_mkr_sek.round(3)} Mkr
          Average orders/email  #{calc.average_orders_per_email.round(3)}
          Average delay         #{calc.average_delay.round(3)} minutes
          Missing order emails  #{calc.missing.length}
          Miss percentage       #{calc.miss_percentage.round(3)}%
        STATSOUTPUT
      end

      def stats!
        puts stats_summary
      end

      def matched_orders_output!
        return unless @matched_csv_path

        CSV.open(@matched_csv_path, "w") do |csv|
          csv << %w[email diff_in_mins ordered_at order_email_at]

          calc.matched.each do |data|
            centra_order = data[:centra]
            rule_order = data[:rule]

            csv << [
              centra_order.email,
              centra_order.delay_in_minutes(rule_order).round(2),
              centra_order.order_date,
              rule_order.order_date
            ]
          end
        end
      end

      def missing_emails_output!
        return unless @csv_path

        CSV.open(@csv_path, "w") do |csv|
          csv << %w[email order_timestamp]

          calc.missing.each do |order|
            csv << [order.email, order.order_date.to_s]
          end
        end
      end
    end
  end
end
