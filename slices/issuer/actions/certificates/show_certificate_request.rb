# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class ShowCertificateRequest < Issuer::Action
        include Deps["inventory.operations.render_certificate_request"]

        params do
          required(:id).value(:integer)
        end

        protected

        def handle_request(request) =
          render_certificate_request.call(request.params[:id])
      end
    end
  end
end
