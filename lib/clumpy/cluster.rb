module Clumpy
  class Cluster
    include ClusterBehavior

    def to_s
      "Clumpy::Cluster(latitude: #{latitude}, longitude: #{longitude}, # size: #{points.size})"
    end
  end
end
