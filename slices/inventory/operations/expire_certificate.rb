# frozen_string_literal: true

module Inventory
  module Operations
    class ExpireCertificate < UpdateCertificate
      protected

      def updatable?(certificate)
        (%w[deployed issued].include?(certificate[:status]) &&
          certificate[:expires_on] <= Time.now) ||
          certificate[:status] == 'renewed'
      end

      def certificate_updates(_certificate, context) =
        {
          status: 'expired',
          expired_at: context[:actioned_at]
        }

      def error(certificate)
        errors = {}
        unless %w[deployed issued].include?(certificate[:status])
          errors.merge!({
                          status: ['must be "deployed", "issued" or "renewed"']
                        })
        end
        unless certificate[:expires_on] &&
               certificate[:expires_on] <= Time.now
          errors.merge!({
                          expires_on: ['is NOT yet reached']
                        })
        end
        errors
      end
    end
  end
end
