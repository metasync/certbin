# frozen_string_literal: true

module Inventory
  module Operations
    class UpdateCertificate < Base
      def call(id, **context)
        context[:actioned_at] = Time.now
        certificate = find_certificate(id)
        if updatable?(certificate)
          certificates.transaction do
            before_update_certificate(certificate, context)
            updated_cert, changes = update_certificate(certificate, context)
            after_update_certificate(updated_cert, context)
            write_audit_log.call(
              id: certificate.id,
              first_id: certificate.first_certificate_id,
              before: certificate,
              after: updated_cert,
              changes:,
              action:,
              actioned_at: context[:actioned_at]
            )
            { certificate: updated_cert }
          end
        else
          render_error(certificate)
        end
      end

      protected

      def find_certificate(id) = certificates.find(id)

      def updatable?(certificate)
        raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
      end

      def update_certificate(certificate, context)
        changes = certificate_updates(certificate, context)
        updated_cert = certificates.update(
          certificate.id,
          updated_at: context[:actioned_at],
          **changes
        )
        [updated_cert, changes]
      end

      def before_update_certificate(_certificate, _context) = {}

      def certificate_updates(certificate, context)
        raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
      end

      def after_update_certificate(updated_cert, context); end

      def render_error(certificate) = {
        error: error(certificate)
      }

      def error(certificate)
        raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
      end
    end
  end
end
