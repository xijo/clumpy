# Clumpy

Little gem to cluster markers, points or anything that responds to `lat` and `lng`.

## Installation

Add this line to your application's Gemfile:

    gem 'clumpy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clumpy

## Usage

It's dead easy:

```ruby
builder  = Clumpy::Builder.new(points)
clusters = builder.cluster
```

Optionally you could add a `precision: :high` option to the builder initialization to move the cluster a little bit after all points were assigned.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

WTFPL - What The Fuck You Want To Public License

Read more at [http://www.wtfpl.net](http://www.wtfpl.net)
