# frozen_string_literal: true

module Inventory
  module Operations
    class RenewCertificateComplete < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'renewing'
      end

      def certificate_updates(_certificate, context) =
        {
          status: 'renewed',
          renewed_at: context[:actioned_at]
        }

      def error(_certificate) =
        { status: ['must be "renewing"'] }
    end
  end
end
