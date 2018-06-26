# Centra

Dealing with Centra stuff, features include

- [Reading export files and generating summaries](#cli-usage)
- [Matching Centra orders with Rule orders](#rule-order-matcher)
- [Import data to a PostgreSQL database](#database-import)
- [Anonymize data](#cli-usage)
- [CLI](#cli-usage)

## CLI Usage

Available CLIs:

- `centra_orders` - Various simple tasks
- `centra_order_import` - Import orders from CSV to database
- `centra_product_import` - Import products from CSV to database
- `centra_rule_matcher` - Match Centra and Rule orders

Use `<command> --help` to see all options.

__Centra stats__

```
$ centra_orders --help
```

Example

```
$ centra_orders --centra-export=centra-order-export.csv      \
                --anonymize                                  \
                --order-frequency-output=order-frequency.csv \
                --anonymized-output=anonymized_orders.csv    \
                --countries=SE,NO                            \
                --start-date=2017-01-01                      \
                --end-date=2018-01-01
```

Example output

```
$ centra_orders --centra-export=sample-centra-order-export.csv --countries=SE

Reading Centra order export file..done!
Parsing and anonymizing  CSV-file (this may take a while)..done!
Running calculations..done!

=== STATS ===
First order date         2013-03-25 09:57:28 +0100
Last order date          2015-06-03 19:23:31 +0200

Total revenue (SEK)      853359.8
Total orders             999
Total orders (in stats)  735
Total pcs                943
Total unique emails      647
Total currencies         1
Total payment types      12
Total countries          1

Avg. orders/email        1.544049459041731
Avg. value/email         1318.948686244204
Avg. pcs/order           0.943943943943944
Avg. order value         854.2140140140141

Purchase frequency       1.544049459041731
Customer value           1318.948686244204
```

## Rule order matcher

```
$ centra_rule_matcher --help
```

Example

```
$ centra_rule_matcher --rule=rule_orders.csv       \
                      --centra=centra_orders.csv   \
                      --max-allowed-diff=90        \
                      --output-missing=missing.csv \
                      --output-matched=matched.csv \
                      --countries=SE,NO            \
                      --start-date=2017-01-01      \
                      --end-date=2018-01-01
```

## Database import

__Orders__

```
$ centra_order_import --help
```

Example

```
$ centra_order_import --centra-export=sample-orders.csv \
                      --dbname=dbname \
                      --user=dbuser \
                      --password=dbpassword \
                      --host=127.0.0.1 \
                      --anonymize \
                      --logger=STDOUT
```

__Products__

```
$ centra_product_import --help
```

Example

```
$ centra_product_import --centra-export=sample-products.csv \
                      --dbname=dbname \
                      --user=dbuser \
                      --password=dbpassword \
                      --host=127.0.0.1 \
                      --anonymize \
                      --logger=STDOUT
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "centra"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install centra

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

:information_source: If you want to test the scripts in `exe` when developing, set the environment variable `CENTRA_GEM_DEV=1`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/centra.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
