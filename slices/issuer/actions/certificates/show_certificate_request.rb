# frozen_string_literal: true

module Issuer
  module Actions
    module Certificates
      class ShowCertificateRequest < Issuer::Action
        include Deps['inventory.operations.render_certificate_request']

        handle_exception NoMethodError => :handle_no_method_error

        params do
          required(:id).value(:integer)
        end

        protected

        def handle_request(request) =
          render_certificate_request.call(request.params[:id])

        def handle_no_method_error(_request, response, _exception)
          cert_template = _exception.message[/undefined method `render_(.+)_certificate_request/,1]
          response.status = :unprocessable_entity
          response.body = { error: "Certificate request template is INVALID: #{cert_template}" }.to_json
        end
      end
    end
  end
end
