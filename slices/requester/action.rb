# auto_register: false
# frozen_string_literal: true

module Requester
  class Action < Certman::Action
    include Deps["inventory.operations.find_certificates"]
  end
end
