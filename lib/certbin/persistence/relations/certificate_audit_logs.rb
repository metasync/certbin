# frozen_string_literal: true

module Certbin
  module Persistence
    module Relations
      class CertificateAuditLogs < ROM::Relation[:sql]
        schema(:certificate_audit_logs, infer: true)
      end
    end
  end
end
