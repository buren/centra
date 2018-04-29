module Centra
  module Rule
    class CSVHeaderConverter
      MAP = {
        'email' => :delivery_email,
        'created_at' => :order_date,
      }.freeze

      def self.call(header)
        MAP.fetch(header) do
          warn "[RULE] Unmapped key: #{header}"
          HoneyFormat::ConvertHeaderValue.call(header)
        end
      end
    end
  end
end
