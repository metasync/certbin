# auto_register: false
# frozen_string_literal: true

module Auditor
  class Action < Certbin::Action
    include Deps['inventory.operations.find_certificate_audit_logs']
  end
end
