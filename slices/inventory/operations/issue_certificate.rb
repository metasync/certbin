# frozen_string_literal: true

require 'base64'
require 'openssl'

module Inventory
  module Operations
    class IssueCertificate < UpdateCertificate
      include Deps['operations.renew_certificate_complete']

      protected

      def updatable?(certificate)
        certificate[:status] == 'requested'
      end

      def before_update_certificate(certificate, context)
        unless certificate.last_certificate_id.nil?
          context[:last_cert] =
            renew_certificate_complete.call(
              certificate.last_certificate_id
            )[:certificate]
        end
        context
      end

      def certificate_updates(_certificate, context) =
        { status: 'issued',
          issued_at: context[:actioned_at] }.merge!(
            decode_certificate(context[:certificate_content])
          )

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

      def error(_certificate) =
        { status: ['must be "requested" or "renewing"'] }
    end
  end
end
