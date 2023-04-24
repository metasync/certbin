# frozen_string_literal: true

module Inventory
  module Operations
    class RetrieveCertificateContent < Base
      def call(id) = {
        certificate: {
          id:,
          cert_content: certificates.find(id).certificate_content
        }
      }
    end
  end
end
