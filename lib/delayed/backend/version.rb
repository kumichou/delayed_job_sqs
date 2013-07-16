module Delayed
  module Backend
    module Sqs
      @@version = nil

      def self.version
        @@version ||= "0.1.0"
      end
    end
  end
end
