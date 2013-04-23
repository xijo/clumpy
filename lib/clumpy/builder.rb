module Clumpy
  class Builder
    MAX_LATITUDE_DISTANCE  = 170.05115
    MAX_LONGITUDE_DISTANCE = 360
    DISTANCE_MODIFIER      = 5

    attr_accessor :points, :options, :clusters

    def initialize(points, options = {})
      @points   = points
      @options  = options || {}
      @clusters = []
    end

    # Clusters the given points
    #
    # == Returns:
    # An array of cluster objects.
    #
    def cluster
      points.each { |point| add_to_cluster(point) }
      options[:precision] == :high and clusters.each(&:reposition)
      clusters
    end

    def add_to_cluster(point)
      useable_point?(point) or return
      parent_cluster = find_parent_cluster(point)

      if parent_cluster
        parent_cluster.points << point
      else
        clusters << cluster_class.new(point, cluster_options)
      end
    end

    def useable_point?(point)
      point.respond_to?(:latitude) && point.respond_to?(:longitude)
    end

    def find_parent_cluster(point)
      clusters.find { |c| c.contains?(point) }
    end

    def cluster_latitude_distance
      latitude_distance / DISTANCE_MODIFIER
    end

    def cluster_longitude_distance
      longitude_distance / (DISTANCE_MODIFIER * 2)
    end

    def cluster_options
      {
        values_threshold: options[:values_threshold],
        include_values: options[:include_values],
        latitude_distance: cluster_latitude_distance,
        longitude_distance: cluster_longitude_distance
      }
    end

    def cluster_class
      @cluster_class ||= (options[:cluster_class] || Clumpy::Cluster)
    end

    def latitude_distance
      if options[:nelat] && options[:swlat]
        (options[:nelat] - options[:swlat]).abs
      else
        MAX_LATITUDE_DISTANCE
      end
    end

    def longitude_distance
      if options[:nelng] && options[:swlng]
        (options[:nelng] - options[:swlng]).abs
      else
        MAX_LONGITUDE_DISTANCE
      end
    end
  end
end
