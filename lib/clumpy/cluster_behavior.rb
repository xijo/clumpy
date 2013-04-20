module Clumpy
  module ClusterBehavior
    attr_accessor :latitude, :longitude, :points, :bounds

    def initialize(point, distance, options = {})
      @latitude  = point.latitude
      @longitude = point.longitude
      @points    = [point]
      @options   = options
      @bounds    = OpenStruct.new(
        latitude: (latitude - distance)..(latitude + distance),
        longitude: (longitude - distance)..(longitude + distance)
      )
    end

    def contains?(point)
      bounds.latitude.include?(point.latitude) &&
      bounds.longitude.include?(point.longitude)
    end

    def reposition
      @latitude  = points.inject(0.0) { |m, p| m + p.latitude } / points.size
      @longitude = points.inject(0.0) { |m, p| m + p.longitude } / points.size
    end

    def as_json(*)
      {
        latitude: latitude,
        longitude: longitude,
        size: points.size,
        bounds: bounds_as_json,
        values: value_list
      }
    end

    def value_list
      case @options[:include_values]
      when true  then points
      when false then []
      else
        values_threshold = @options[:values_threshold] || 10
        points.size <= values_threshold ? points : []
      end
    end

    def bounds_as_json
      {
        northeast: {
          latitude: bounds.latitude.max,
          longitude: bounds.longitude.max
        },
        southwest: {
          latitude: bounds.latitude.min,
          longitude: bounds.longitude.max
        }
      }
    end
  end
end
