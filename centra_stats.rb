# CLI
require 'optparse'
require_relative 'cli'

args = CLI.parse!

centra_export_file = args.fetch(:centra_export_file)
order_freq_output = args.fetch(:order_freq_output)
anonymized_output = args.fetch(:anonymized_output)
anonymize = args.fetch(:anonymize)

# Main
require_relative 'centra_data'
require_relative 'centra_calculations'

print "Reading Centra order export file.."
centra_orders_csv_file = File.read(centra_export_file)
puts 'done!'
print "Parsing CSV-file (this may take a while).."
centra_data = CentraData.new(centra_orders_csv_file)
puts 'done!'

if anonymize
  print 'Anonymizing/scrubbing personal details..'
  centra_data.anonymize!
  puts 'done!'
end

if anonymized_output
  unless anonymize
    fail('--anonymize option must be true in order to write anonymized order file.')
  end

  print "Writing anonymized order file #{anonymized_output}.."
  CSV.open(anonymized_output, 'w') do |anon_csv|
    anon_csv << centra_data.header
    centra_data.rows.each do |row|
      anon_csv << row.to_a
    end
  end
  puts 'done!'
end

print 'Running calculatations..'
calculatation = CentraCalculations.new(centra_data)
result = calculatation.calculate.result
puts 'done!'

if order_freq_output
  print "Writing output file #{order_freq_output}.."
  CSV.open(order_freq_output, 'w') do |output_csv|
    output_csv << %w[email order_count]
    sorted_orders_per_email_asc = result[:orders_per_email].to_a.sort_by { |d| d.last }
    sorted_orders_per_email_asc.reverse_each { |row| output_csv << row }
  end
  puts 'done!'
end

puts
puts '=== STATS ==='
puts "First order date:     #{result[:first_order_date]}"
puts "Last order date:      #{result[:last_order_date]}"
puts
puts "Total revenue:        #{result[:total_revenue]}"
puts "Total orders:         #{result[:total_orders]}"
puts "Total pcs:            #{result[:total_pcs]}"
puts "Total unique emails:  #{result[:total_unique_emails]}"
puts "Total currencies:     #{result[:total_currencies]}"
puts
puts "Avg. orders/email:    #{result[:avg_order_per_email]}"
puts "Avg. value/email:     #{result[:avg_value_per_email]}"
puts "Avg. pcs/order:       #{result[:avg_pcs_per_order]}"
puts "Avg. order value:     #{result[:avg_order_value]}"
puts '============='
puts
