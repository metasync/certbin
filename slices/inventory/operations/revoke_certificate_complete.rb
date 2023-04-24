# frozen_string_literal: true

module Inventory
  module Operations
    class RevokeCertificateComplete < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'revoking'
      end

      def certificate_updates(_certificate) =
        {
          status: 'revoked',
          revoked_at: Time.now
        }

      def error(_certificate) =
        { status: ['must be "revoking"'] }
    end
  end
end
