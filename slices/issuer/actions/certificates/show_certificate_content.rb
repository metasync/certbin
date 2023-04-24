# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class ShowCertificateContent < Issuer::Action
        include Deps['inventory.operations.retrieve_certificate_content']

        params do
          required(:id).value(:integer)
        end

        protected

        def handle_request(request) =
          retrieve_certificate_content.call(request.params[:id])
      end
    end
  end
end
