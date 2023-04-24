# frozen_string_literal: true

module Inventory
  module Operations
    class RenewCertificate < UpdateCertificate
      protected

      def updatable?(certificate) =
        (expired?(certificate) || expiring?(certificate))

      def expired?(certificate)
        certificate[:status] == 'expired'
      end

      def expiring?(certificate)
        now = Time.now
        certificate[:status] == 'deployed' &&
          certificate[:expires_on] <=
            now + (settings.days_before_renewal * 24 * 60 * 60) &&
          certificate[:expires_on] > now
      end

      def certificate_updates(_certificate) =
        { status: 'renewing' }

      def error(_certificate) =
        { status: ["must be \"expired\" or \"expiring\" in #{settings.days_before_renewal} days"] }
    end
  end
end
