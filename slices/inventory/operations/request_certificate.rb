# frozen_string_literal: true

module Inventory
  module Operations
    class RequestCertificate < Base
      def call(certificate, **context)
        context[:actioned_at] = Time.now
        certificates.transaction do
          new_certificate = certificates.create(new_certificate(certificate, context))
          first_certificate_id = context[:first_certificate_id] || new_certificate.id
          updated_cert = certificates.update(
            new_certificate.id,
            first_certificate_id:
          )
          certificate[:first_certificate_id] = updated_cert.first_certificate_id
          write_audit_log.call(
            id: new_certificate.id,
            first_id: first_certificate_id,
            before: new_certificate,
            after: updated_cert,
            changes: certificate,
            action:,
            actioned_at: context[:actioned_at]
          )
          { certificate: updated_cert }
        end
      end

      protected

      def new_certificate(certificate, context)
        certificate[:dns_records].map! do |dns_record|
          {
            value: dns_record,
            updated_at: context[:actioned_at],
            created_at: context[:actioned_at]
          }
        end
        certificate[:ip_addresses].map! do |ip_address|
          {
            value: ip_address,
            updated_at: context[:actioned_at],
            created_at: context[:actioned_at]
          }
        end
        certificate.merge!(
          organization: settings.organization,
          locality: settings.locality,
          state_or_province: settings.state_or_province,
          country: settings.country,
          status: 'requested',
          requested_at: context[:actioned_at],
          updated_at: context[:actioned_at],
          created_at: context[:actioned_at]
        )
      end
    end
  end
end
