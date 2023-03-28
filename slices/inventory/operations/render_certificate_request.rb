# frozen_string_literal: true

module Inventory
  module Operations
    class RenderCertificateRequest < Base
      include Deps["renderers.certificate_request"]

      def call(id) = {
        certificate: {
          id: id,
          cert_request: render_certificate_request(certificates.find(id))
        }
      }

      protected

      def render_certificate_request(certificate) =
        certificate_request.send(
          "render_#{certificate[:template]}_certificate_request",
          certificate
        )
    end
  end
end