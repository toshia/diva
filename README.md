# Diva

This library is an implementation of expression for handling things.
It replaces Retriever module of mikutter.

Diva::Model is a common interface of all resources handled by mikutter.
By handling data as a subclass of Diva::Model as necessary,
you can obtain a common interface and it is useful for cooperation
among mikutter plugins.

[![toshia](https://circleci.com/gh/toshia/diva.svg?style=svg)](https://circleci.com/gh/toshia/diva)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'diva'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diva

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/diva.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

