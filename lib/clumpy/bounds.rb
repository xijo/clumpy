module Clumpy
  class Bounds
    def initialize(latitude, longitude, width, length)
      l = length / 2
      w = width / 2
      @latitude  = (latitude - l)..(latitude + l)
      @longitude = (longitude - w)..(longitude + w)
    end

    attr_reader :latitude

    attr_reader :longitude

    def as_json(*)
      {
        northeast: {
          latitude: @latitude.end,
          longitude: @longitude.end,
        },
        southwest: {
          latitude: @latitude.begin,
          longitude: @longitude.begin,
        }
      }
    end
  end
end

