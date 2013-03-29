module Clumpy
  module Extensions
    module SunspotHit
      def latitude
        stored(:lat)
      end

      def longitude
        stored(:lng)
      end

      def as_json(*)
        {
          id: primary_key,
          type: class_name
        }
      end
    end
  end
end
