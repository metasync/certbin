# frozen_string_literal: true

module Requester
  class Slice < Hanami::Slice
    import keys: [
             'operations.request_certificate',
             'operations.cancel_certificate_request',
             'operations.find_certificates'
           ],
           from: :inventory
  end
end
