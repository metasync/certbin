# frozen_string_literal: true

module Inventory
  module Operations
    class WriteAuditLog
      include Deps['repositories.certificate_audit_logs']

      include Certbin::Middleware::Warden::Auth

      def actioned_by
        auth.value!.dig('data', 'user')
      end

      def action_group
        auth.value!['iss']
      end

      def call(id:, first_id:, before:, after:, changes:, action:, actioned_at:)
        certificate_audit_logs.create(
          certificate_id: id,
          first_certificate_id: first_id,
          # before: before.to_h.to_json,
          # after: after.to_h.to_json,
          changes: changes.to_json,
          action:,
          actioned_by:,
          action_group:,
          actioned_at:,
          created_at: Time.now
        )
      end
    end
  end
end
