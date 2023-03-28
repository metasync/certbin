# frozen_string_literal: true

module Inventory
  module Operations
    class IssueCertificate < UpdateCertificate
      protected

      def updatable?(certificate) =
        ["requested", "renewing"].include?(certificate[:status])

      def certificate_updates(certificate, **opts)
        {
          status: "issued",
          certificate_content: opts[:certificate_content],
          serial_number: opts[:serial_number],
          issued_on: opts[:issued_on],
          expires_on: opts[:expires_at],
          issuer: opts[:issuer]
        }.merge!(
          case certificate.status
          when "requested"
            { issued_at: Time.now }
          when "renewing"
            { renewed_at: Time.now }
          else
            {}
          end
        )
      end

      def error(certificate) =
        { status: ['must be "requested" or "renewing"'] }
    end
  end
end