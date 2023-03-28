# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class Renew < Issuer::Action
        include Deps["inventory.operations.renew_certificate"]

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          renew_certificate.call(request.params[:id])
      end
    end
  end
end
