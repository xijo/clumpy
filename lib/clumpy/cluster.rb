module Clumpy
  class Cluster
    attr_accessor :latitude, :longitude, :points

    def initialize(point, distance)
      @latitude, @longitude = point.lat, point.lng
      @bb_latitudes  = (latitude - distance)..(latitude + distance)
      @bb_longitudes = (longitude - distance)..(longitude + distance)
      @points = [point]
    end

    def contains?(point)
      point.respond_to?(:lat) &&
        point.respond_to?(:lng) &&
        @bb_latitudes.include?(point.lat) &&
        @bb_longitudes.include?(point.lng)
    end

    def reposition
      @latitude  = points.inject(0) { |m, p| m + p.lat } / points.size
      @longitude = points.inject(0) { |m, p| m + p.lng } / points.size
    end

    def as_json(*)
      {
        swlat: @bb_latitudes.min,
        swlng: @bb_longitudes.min,
        nelat: @bb_latitudes.max,
        nelng: @bb_longitudes.max,
        lat: latitude,
        lng: longitude,
        points: points.length
      }
    end

    def to_s
      "Clumpy::Cluster(latitude: #{latitude}, longitude: #{longitude}, # points: #{points.length})"
    end
  end
end
