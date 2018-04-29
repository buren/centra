require 'securerandom'
# require 'honey_format'

require_relative 'anon_value'
require_relative 'centra_csv_header_converter'

class CentraData
  attr_reader :header, :rows

  def initialize(file)
    csv = parse_csv(file)
    @header = CSVHeader.new(csv.first)
    @rows = csv[1..-1] # ignore the header row
  end

  def column_index(name)
    header.find_index(name)
  end
  alias_method :col_index, :column_index

  def columns
    header.columns
  end

  # make sure the same email gets the same anonymized email
  def anonymize!
    email_map = AnonValue.new

    rows.map! do |row|
      email = row[column_index(:email)]

      anon_email = email_map.value_for(email) { "#{SecureRandom.uuid}@example.com" }
      row[column_index(:email)] = anon_email
      row
    end
  end

  private

  def parse_csv(string)
    # HoneyFormat::CSV.new(string, header_converter: CentraCSVHeaderConverter)
    CSV.parse(string)
  end
end
