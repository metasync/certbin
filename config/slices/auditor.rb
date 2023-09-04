# frozen_string_literal: true

module Auditor
  class Slice < Hanami::Slice
    import keys: [
             'operations.find_certificate_audit_logs'
           ],
           from: :inventory
  end
end
