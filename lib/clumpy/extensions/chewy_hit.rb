module Clumpy
  module Extensions
    module ChewyHit
      def latitude
        @latitude ||= lat.to_f
      end

      def longitude
        @longitude ||= lng.to_f
      end

      def as_json(*)
        {
          id:   id,
          type: _source.full?(:type) || type.classify
        }
      end
    end
  end
end
