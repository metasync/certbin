# frozen_string_literal: true

module Auditor
  module Actions
    module AuditLogs
      class FindByAttribute < Finder
        params do
          required(:value).filled(:string)
        end

        protected

        def find(params)
          find_certificate_audit_logs.send("by_#{attribute}", params[:value])
        end

        def attribute = inflector.singularize(
          inflector.tableize(self.class.name.split('FindBy').last)
        )
      end
    end
  end
end
