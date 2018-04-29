# Centra

Dealing with Centra stuff, i.e

- reading export files and generating summaries.
- matching Centra orders with Rule orders

## Usage

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

__Rule order matcher__

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
