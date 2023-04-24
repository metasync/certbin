# frozen_string_literal: true

module Issuer
  class Slice < Hanami::Slice
    import keys: [
             'operations.find_certificates',
             'operations.render_certificate_request',
             'operations.retrieve_certificate_content',
             'operations.issue_certificate',
             'operations.renew_certificate',
             'operations.revoke_certificate',
             'operations.revoke_certificate_complete',
             'operations.expire_certificate'
           ],
           from: :inventory
  end
end
