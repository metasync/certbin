# frozen_string_literal: true

module Auditor
  module Actions
    module AuditLogs
      class FindByAttributeWithLimit < FindByAttribute
        params do
          required(:value).filled(:string)
          optional(:limit).value(:integer, gteq?: 1)
          optional(:offset).value(:integer, gteq?: 0)
        end

        protected

        def find(params)
          limit = params[:limit] || 500
          offset = params[:offset] || 0
          find_certificate_audit_logs.send(
            "by_#{attribute}",
            params[:value], limit:, offset:
          )
        end
      end
    end
  end
end
