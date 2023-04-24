# frozen_string_literal: true

module Requester
  module Actions
    module Certificates
      class Cancel < Requester::Action
        include Deps['inventory.operations.cancel_certificate_request']

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          cancel_certificate_request.call(request.params[:id])
      end
    end
  end
end
