module Clumpy
  module Extensions
    module ChewyHit
      def latitude
        @latitude ||= _source.lat.to_f
      end

      def longitude
        @longitude ||= _source.lng.to_f
      end

      def as_json(*)
        {
          id:   _source.id,
          type: _source.full?(:type) || type.classify
        }
      end
    end
  end
end
