# frozen_string_literal: true

module Inventory
  module Operations
    class RenewCertificate < UpdateCertificate
      include Deps['operations.request_certificate']

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

      def before_update_certificate(certificate, context)
        context[:new_certificate] =
          request_certificate.call(
            certificate_request(certificate),
            first_certificate_id: certificate.id
          )[:certificate]
        context
      end

      def certificate_updates(_certificate, context)
        { status: 'renewing', next_certificate_id: context[:new_certificate].id }
      end

      def certificate_request(certificate)
        {
          organization_unit: certificate.organization_unit,
          organization: certificate.organization,
          locality: certificate.locality,
          state_or_province: certificate.state_or_province,
          country: certificate.country,

          owner: certificate.owner,
          email: certificate.email,

          environment: certificate.environment,
          application: certificate.application,

          template: certificate.template,
          key_size: certificate.key_size,
          common_name: certificate.common_name,
          dns_records: certificate.dns_records.map(&:value),
          ip_addresses: certificate.ip_addresses.map(&:value),
          host: certificate.host,
          install_method: certificate.install_method, # Windows / IIS / Manual
          reference_id: certificate.reference_id,

          first_certificate_id: certificate.first_certificate_id,
          last_certificate_id: certificate.id
        }
      end

      def error(_certificate) =
        { status: ["must be \"expired\" or \"expiring\" in #{settings.days_before_renewal} days"] }
    end
  end
end
