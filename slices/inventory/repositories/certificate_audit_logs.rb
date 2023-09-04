# frozen_string_literal: true

module Inventory
  module Repositories
    class CertificateAuditLogs < Certbin::Repository[:certificate_audit_logs]
      include Deps['repositories.certificates']

      commands :create

      def find_by_certificate_id(certificate_id)
        certificate_audit_logs.where(certificate_id:).to_a
      end

      def find_by_first_certificate_id(first_certificate_id)
        certificate_audit_logs.where(first_certificate_id:).to_a
      end

      def find_by_action(action, limit:, offset:)
        certificate_audit_logs.where(action:).limit(limit, offset).to_a
      end

      def find_by_actioned_by(actioned_by, limit:, offset:)
        certificate_audit_logs.where(actioned_by:).limit(limit, offset).to_a
      end

      def find_by_action_group(action_group, limit:, offset:)
        certificate_audit_logs.where(action_group:).limit(limit, offset).to_a
      end

      def delete_all =
        certificate_audit_logs.command(:delete).call
    end
  end
end
