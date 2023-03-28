# frozen_string_literal: true

module Inventory
  module Operations
    class DeployCertificateComplete < UpdateCertificate
      protected

      def updatable?(certificate) =
        certificate[:status] == "issued"

      def certificate_updates(certificate) = 
        {
          status: "deployed",
          deployed_at: Time.now
        }

      def error(certificate) = 
        { status: ['must be "issued"']}
    end
  end
end