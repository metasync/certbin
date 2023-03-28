# frozen_string_literal: true

module Certman
  module Persistence
    module Relations
      class Certificates < ROM::Relation[:sql]
        schema(:certificates, infer: true) do
          associations do
            has_many :certificate_ip_addresses, as: :ip_addresses
            has_many :certificate_dns_records, as: :dns_records
          end
        end
      end
    end
  end
end
