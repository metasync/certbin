# frozen_string_literal: true

module Inventory
  module Repositories
    class CertificateDnsRecords < Certbin::Repository[:certificate_dns_records]
      commands :create, delete: :by_pk
    end
  end
end
