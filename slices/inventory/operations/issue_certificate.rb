# frozen_string_literal: true

require "base64"
require "openssl"

module Inventory
  module Operations
    class IssueCertificate < UpdateCertificate
      protected

      def updatable?(certificate) =
        ["requested", "renewing"].include?(certificate[:status])

      def certificate_updates(certificate, certificate_content:)
        { status: "issued" }.merge!(
          decode_certificate(certificate_content)
        ).merge!(
          case certificate.status
          when "requested"
            { issued_at: Time.now }
          when "renewing"
            { renewed_at: Time.now }
          else
            {}
          end
        )
      end

      def decode_certificate(content)
        { certificate_content: content[:pfx] }.merge!(
          decode_x509_certificate(Base64.decode64(content[:crt]))
        )
      end

      def decode_x509_certificate(content)
        certificate = OpenSSL::X509::Certificate.new(content)
        {
          serial_number: certificate.serial.to_s,
          issued_on: certificate.not_before,
          expires_on: certificate.not_after,
          issuer: certificate.issuer.to_s(OpenSSL::X509::Name::RFC2253)
        }
      end

      def error(certificate) =
        { status: ['must be "requested" or "renewing"'] }
    end
  end
end