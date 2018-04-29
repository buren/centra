# Centra

Dealing with Centra stuff, i.e reading export files and generating summaries.

## Usage

```
$ centra_stats --help
```

Example

```
centra_stats --centra-export=centra-order-export.csv      \
             --anonymize                                  \
             --order-frequency-output=order-frequency.csv \
             --anonymized-output=anonymized_orders.csv    \
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

:information_source: If you want to test the scripts in `exe` when developing, set the environment variable

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/centra.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
