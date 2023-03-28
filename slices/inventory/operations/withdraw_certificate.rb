# frozen_string_literal: true

module Inventory
  module Operations
    class WithdrawCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == "revoked"
      end

      def certificate_updates(certificate) = {
        status: "withdrawn",
        withdrawn_at: Time.now,
      }

      def error(certificate) =
        { status: ['must be "revoked"'] }
    end
  end
end