# CLI
require 'optparse'
require_relative 'cli'

args = CLI.parse!

centra_export_file = args[:centra_export_file]
order_freq_output = args[:order_freq_output]
anonymized_output = args[:anonymized_output]
anonymize = args[:anonymize]

# Main
require 'csv'
require_relative 'csv_header'
require_relative 'anon_value'

print "Reading Centra order export file.."
centra_orders_csv_file = File.read(centra_export_file)
puts 'done!'
print "Parsing CSV-file (this may take a while).."
csv = CSV.parse(centra_orders_csv_file)
header = CSVHeader.new(csv.first)
rows = csv[1..-1] # ignore the header row
puts 'done!'

CSV_EMAIL_COLUMN_OFFSET = header.find_index('Delivery Email')
CSV_PCS_COLUMN_OFFSET = header.find_index('Pcs')
CSV_REVENUE_COLUMN_OFFSET = header.find_index('Total Order Value (SEK)')

if anonymize
  require 'securerandom'

  # make sure the same email gets the same anonymized email
  email_map = AnonValue.new
  print 'Anonymizing/scrubbing personal details..'
  rows.map! do |row|
    email = row[CSV_EMAIL_COLUMN_OFFSET]

    anon_email = email_map.value_for(email) { "#{SecureRandom.uuid}@example.com" }
    row[CSV_EMAIL_COLUMN_OFFSET] = anon_email
    row
  end
  puts 'done!'
end

if anonymized_output
  unless anonymize
    fail('--anonymize option must be true in order to write anonymized order file.')
  end

  print "Writing anonymized order file #{anonymized_output}.."
  CSV.open(anonymized_output, 'w') do |anon_csv|
    anon_csv << header.columns
    rows.each do |row|
      anon_csv << row
    end
  end
  puts 'done!'
end

print 'Running calculatations..'
orders_per_email = Hash.new(0)
total_revenue = 0
total_pcs = 0
rows.each do |row|
  email = row[CSV_EMAIL_COLUMN_OFFSET]
  orders_per_email[email] += 1
  total_revenue += row[CSV_REVENUE_COLUMN_OFFSET].to_f
  total_pcs += row[CSV_PCS_COLUMN_OFFSET].to_i
end
puts 'done!'

if order_freq_output
  print "Writing output file #{order_freq_output}.."
  CSV.open(order_freq_output, 'w') do |output_csv|
    output_csv << %w[email order_count]
    sorted_orders_per_email_asc = orders_per_email.to_a.sort_by { |data| data.last }
    sorted_orders_per_email_asc.reverse_each { |row| output_csv << row }
  end
  puts 'done!'
end

total_orders = rows.length
total_unique_emails = orders_per_email.keys.length

avg_order_per_email = total_orders / total_unique_emails.to_f
avg_value_per_email = total_revenue / total_unique_emails.to_f
avg_pcs_per_order = total_pcs / total_orders.to_f
avg_order_value = total_revenue / total_orders.to_f

puts
puts '=== STATS ==='
puts "Total revenue:        #{total_revenue}"
puts "Total orders:         #{total_orders}"
puts "Total pcs:            #{total_pcs}"
puts "Total unique emails:  #{total_unique_emails}"
puts
puts "Avg. orders/email:    #{avg_order_per_email}"
puts "Avg. value/email:     #{avg_value_per_email}"
puts "Avg. pcs/order:       #{avg_pcs_per_order}"
puts "Avg. order value:     #{avg_order_value}"
puts '============='
puts
