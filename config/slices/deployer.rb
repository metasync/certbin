# frozen_string_literal: true

module Deployer
  class Slice < Hanami::Slice
    import keys: [
        "operations.find_certificates",
        "operations.deploy_certificate_complete",
        "operations.retire_certificate",
        "operations.withdraw_certificate"
      ],
      from: :inventory
  end
end
