# frozen_string_literal: true

module Inventory
  module Operations
    class RevokeCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        ["deployed", "issued"].include?(certificate[:status])
      end

      def certificate_updates(certificate) = 
        { status: "revoking" }

      def error(certificate) =
        { status: ['must be "deployed" or "issued"'] }
    end
  end
end