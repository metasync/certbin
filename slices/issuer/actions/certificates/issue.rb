# frozen_string_literal: true

require "openssl"

module Issuer
  module Actions
    module Certificates
      class Issue < Issuer::Action
        include Deps["inventory.operations.issue_certificate"]

        handle_exception OpenSSL::X509::CertificateError => :handle_certificate_error

        params do
          required(:certificate).hash do
            required(:id).filled(:integer)
            required(:certificate_content).filled(:string)
          end
        end

        protected

        def handle_request(request)
          cert_params = request.params[:certificate]
          certificate = decode_certificate(cert_params[:certificate_content])
          issue_certificate.call(
            cert_params[:id],
            certificate_content: 
              cert_params[:certificate_content],
            serial_number: certificate.serial.to_s,
            issued_on: certificate.not_before,
            expires_on: certificate.not_after,
            issuer: certificate.issuer.to_s(OpenSSL::X509::Name::RFC2253)
          )
        end

        def decode_certificate(content)
          OpenSSL::X509::Certificate.new(content)
        end

        def handle_certificate_error(request, response, exception)
          response.status = :unprocessable_entity
          response.body = { error: exception.message }.to_json
        end
      end
    end
  end
end
