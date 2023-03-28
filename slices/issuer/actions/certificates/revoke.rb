# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class Revoke < Issuer::Action
        include Deps["inventory.operations.revoke_certificate"]

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          revoke_certificate.call(request.params[:id])
      end
    end
  end
end
