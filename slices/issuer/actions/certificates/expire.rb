# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class Expire < Issuer::Action
        include Deps["inventory.operations.expire_certificate"]

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          expire_certificate.call(request.params[:id])
      end
    end
  end
end
