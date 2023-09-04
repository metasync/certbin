# frozen_string_literal: true

module Auditor
  module Actions
    module AuditLogs
      class Finder < Auditor::Action
        include Deps['inflector']

        protected

        def handle_request(request) = find(request.params)
        def success_body(result) = serialize(result[:audit_logs])

        def find(params)
          raise NotImplementedError, "#{self.class.name}##{__method__} is an abstract method."
        end

        def serialize(audit_logs) = audit_logs.map(&:to_h).to_json
      end
    end
  end
end
