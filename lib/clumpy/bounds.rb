module Clumpy
  class Bounds
    def initialize(latitude, longitude, side_length)
      side_length ||= 10
      @latitude  = (latitude - side_length)..(latitude + side_length)
      @longitude = (longitude - side_length*2)..(longitude + side_length*2)
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

