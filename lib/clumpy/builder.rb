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
      parent_cluster = find_parent_cluster(point)

      if parent_cluster
        parent_cluster.points << point
      else
        clusters << Cluster.new(point, cluster_distance)
      end
    end

    def find_parent_cluster(point)
      clusters.find { |c| c.contains?(point) }
    end

    def cluster_distance
      latitude_distance / DISTANCE_MODIFIER
    end

    def latitude_distance
      if options[:nelat] && options[:swlat]
        (options[:nelat] - options[:swlat]).abs
      else
        MAX_LATITUDE_DISTANCE
      end
    end
  end
end
