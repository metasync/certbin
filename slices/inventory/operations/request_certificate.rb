# frozen_string_literal: true

module Inventory
  module Operations
    class RequestCertificate < Base
      def call(certificate) = {
        certificate: certificates.create(new_certificate(certificate))
      }

      protected

      def new_certificate(certificate)
        now = Time.now
        certificate[:dns_records].map! do |dns_record|
          { 
            value: dns_record,
            updated_at: now,
            created_at: now
           }
        end
        certificate[:ip_addresses].map! do |ip_address|
          {
            value: ip_address,
            updated_at: now,
            created_at: now
          }
        end
        certificate.merge!(
          organization: settings.organization,
          locality: settings.locality,
          state_or_province: settings.state_or_province,
          country: settings.country,
          status: "requested",
          requested_at: now,
          updated_at: now,
          created_at: now
        )
      end
    end
  end
end
