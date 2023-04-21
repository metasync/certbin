# frozen_string_literal: true

require "openssl"

module Issuer
  module Actions
    module Certificates
      class Issue < Issuer::Action
        include Deps["inventory.operations.issue_certificate"]

        handle_exception OpenSSL::X509::CertificateError => :handle_certificate_error
        handle_exception OpenSSL::PKCS12::PKCS12Error => :handle_certificate_error

        params do
          required(:id).filled(:integer)
          required(:certificate_pfx).filled(:string)
          required(:certificate_crt).filled(:string)
        end

        protected

        def handle_request(request)
          issue_certificate.call(
            request.params[:id],
            certificate_content: {
              pfx: request.params[:certificate_pfx],
              crt: request.params[:certificate_crt]
            }
          )
        end

        def handle_certificate_error(request, response, exception)
          response.status = :unprocessable_entity
          response.body = { error: exception.message }.to_json
        end
      end
    end
  end
end
