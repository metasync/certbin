# frozen_string_literal: true

module Certbin
  module Persistence
    module Relations
      class CertificateDnsRecords < ROM::Relation[:sql]
        schema(:certificate_dns_records, infer: true) do
          associations do
            belongs_to :certificate
          end
        end
      end
    end
  end
end
