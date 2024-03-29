# frozen_string_literal: true

module Inventory
  module Operations
    class RevokeCertificateComplete < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'revoking'
      end

      def certificate_updates(_certificate, context) =
        {
          status: 'revoked',
          revoked_at: context[:actioned_at]
        }

      def error(_certificate) =
        { status: ['must be "revoking"'] }
    end
  end
end
