# Clumpy

Cluster markers, geocoordinates or anything that responds to `latitude` and `longitude`.

## Why serverside clustering

Of cause there are lots of libs to cluster large amounts of markers in the frontend, but the expensive part is to
transfer all those markers to the client. In my case it was the difference between sending 10_000 markers - or 20.

## Installation

As part of the Gemfile or by hand, nothing unusual here.

## Usage

Clumpy takes points, typically geocoordinates, and puts them together into clusters.

It requires the given points to be ruby objects, responding to `latitude` and `longitude` methods.

```ruby
require 'ostruct'

Point = Struct.new(:latitude, :longitude)
points = [
  Point.new(latitude: 101, longitude: 11),
  Point.new(latitude: 102, longitude: 12),
  Point.new(latitude: 201, longitude: 21)
]
```

Now those points may be clustered easily:

```ruby
builder  = Clumpy::Builder.new(points)
clusters = builder.cluster

cluster = clusters.first
cluster.size                 # => 2
cluster.latitude             # => 101.5
cluster.longitude            # => 11.5
cluster.points               # => points 1 and 2 from above
cluster.bounds               # => represents the area this cluster covers
cluster.to_json              # => well, json representation of that.
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
