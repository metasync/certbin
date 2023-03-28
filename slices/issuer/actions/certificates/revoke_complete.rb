# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class RevokeComplete < Issuer::Action
        include Deps["inventory.operations.revoke_certificate_complete"]

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          revoke_certificate_complete.call(request.params[:id])
      end
    end
  end
end
