# frozen_string_literal: true

module Requester
  module Actions
    module Certificates
      class Finder < Requester::Action
        include Deps['inflector']

        protected

        def handle_request(request) = find(request.params)
        def success_body(result) = serialize(result[:certificates])

        def find(params)
          raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
        end

        def serialize(certificates) = certificates.map(&:to_h).to_json
      end
    end
  end
end
