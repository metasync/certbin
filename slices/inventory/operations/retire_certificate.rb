# frozen_string_literal: true

module Inventory
  module Operations
    class RetireCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        certificate[:status] == 'expired' &&
          certificate[:expired_at] <=
            Time.now - (settings.days_before_retirement * 24 * 60 * 60)
      end

      def certificate_updates(_certificate, context) = {
        status: 'retired',
        retired_at: context[:actioned_at]
      }

      def error(_certificate) =
        { status: ["must be \"expired\" over #{settings.days_before_retirement} days"] }
    end
  end
end
