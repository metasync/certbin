# frozen_string_literal: true

module Inventory
  module Operations
    class DeployCertificateComplete < UpdateCertificate
      include Deps['operations.expire_certificate']

      protected

      def updatable?(certificate) =
        certificate[:status] == 'issued'

      def before_update_certificate(certificate, context)
        unless certificate.last_certificate_id.nil?
          context[:last_cert] =
            expire_certificate.call(
              certificate.last_certificate_id
            )[:certificate]
        end
        context
      end

      def certificate_updates(_certificate, context) =
        {
          status: 'deployed',
          deployed_at: context[:actioned_at]
        }

      def error(_certificate) =
        { status: ['must be "issued"'] }
    end
  end
end
