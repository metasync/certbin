# frozen_string_literal: true

module Certbin
  module Persistence
    module Relations
      class CertificateHosts < ROM::Relation[:sql]
        schema(:certificate_hosts, infer: true) do
          associations do
            belongs_to :certificate
          end
        end
      end
    end
  end
end
