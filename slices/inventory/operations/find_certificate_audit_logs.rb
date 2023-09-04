# frozen_string_literal: true

module Inventory
  module Operations
    class FindCertificateAuditLogs < Base
      include Deps['repositories.certificate_audit_logs']

      def by_certificate_id(certificate_id)
        { audit_logs: certificate_audit_logs.find_by_certificate_id(certificate_id) }
      end

      def by_first_certificate_id(first_certificate_id)
        { audit_logs: certificate_audit_logs.find_by_first_certificate_id(first_certificate_id) }
      end

      def by_action(action, limit:, offset:)
        { audit_logs: certificate_audit_logs.find_by_action(action, limit:, offset:) }
      end

      def by_actioned_by(actioned_by, limit:, offset:)
        { audit_logs: certificate_audit_logs.find_by_actioned_by(actioned_by, limit:, offset:) }
      end

      def by_action_group(action_group, limit:, offset:)
        { audit_logs: certificate_audit_logs.find_by_action_group(action_group, limit:, offset:) }
      end
    end
  end
end
