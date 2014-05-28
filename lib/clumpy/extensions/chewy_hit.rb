module Clumpy
  module Extensions
    class ChewyHit
      def initialize(original_hash)
        @original_hash = original_hash
      end

      def latitude
        @original_hash['_source']['lat'].to_f
      end

      def longitude
        @original_hash['_source']['lng'].to_f
      end

      def as_json(*)
        {
          id:   @original_hash['_source']['id'],
          type: @original_hash['_source']['type']
        }
      end
    end
  end
end
