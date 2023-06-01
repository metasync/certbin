# frozen_string_literal: true

module Certbin
  module Persistence
    module Relations
      class CertificateIpAddresses < ROM::Relation[:sql]
        schema(:certificate_ip_addresses, infer: true) do
          associations do
            belongs_to :certificate
          end
        end
      end
    end
  end
end
