# frozen_string_literal: true

module Inventory
  module Operations
    class WithdrawCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'revoked'
      end

      def certificate_updates(_certificate, context) = {
        status: 'withdrawn',
        withdrawn_at: context[:actioned_at]
      }

      def error(_certificate) =
        { status: ['must be "revoked"'] }
    end
  end
end
