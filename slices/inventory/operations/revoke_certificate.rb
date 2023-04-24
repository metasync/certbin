# frozen_string_literal: true

module Inventory
  module Operations
    class RevokeCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        %w[deployed issued].include?(certificate[:status])
      end

      def certificate_updates(_certificate) =
        { status: 'revoking' }

      def error(_certificate) =
        { status: ['must be "deployed" or "issued"'] }
    end
  end
end
