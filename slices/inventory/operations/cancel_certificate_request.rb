# frozen_string_literal: true

module Inventory
  module Operations
    class CancelCertificateRequest < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'requested'
      end

      def certificate_updates(_certificate, context) =
        {
          status: 'cancelled',
          cancelled_at: context[:actioned_at]
        }

      def error(_certificate) =
        { status: ['must be "requested"'] }
    end
  end
end
