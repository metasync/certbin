# frozen_string_literal: true

module Inventory
  module Repositories
    class CertificateIpAddresses < Certbin::Repository[:certificate_ip_addresses]
      commands :create, delete: :by_pk
    end
  end
end
