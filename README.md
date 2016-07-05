# sg

`sg` gem allows you to access SendGrid API v3 endpoints from command line interface.

## Installation

You can install the `sg` via gem command:

    $ gem install sg

## Usage

### Setup

`sg` loads your SendGrid API Key from `SENDGRID_API_KEY` environment variable if you do not specify. So set your API Key to your environment variable.

    $ env | grep SENDGRID_API_KEY
    SENDGRID_API_KEY=SG...

### Basic Usage

See help.

    $ bundle exec sg client help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec sg` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
