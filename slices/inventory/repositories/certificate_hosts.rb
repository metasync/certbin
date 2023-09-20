# frozen_string_literal: true

module Inventory
  module Repositories
    class CertificateHosts < Certbin::Repository[:certificate_hosts]
      commands :create, delete: :by_pk
    end
  end
end
