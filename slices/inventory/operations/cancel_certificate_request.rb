# frozen_string_literal: true

module Inventory
  module Operations
    class CancelCertificateRequest < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == "requested"
      end

      def certificate_updates(certificate) = 
        { 
          status: "cancelled",
          cancelled_at: Time.now
        }

      def error(certificate) = 
        { status: ['must be "requested"'] }
    end
  end
end