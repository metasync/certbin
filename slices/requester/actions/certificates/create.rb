# frozen_string_literal: true

module Requester
  module Actions
    module Certificates
      class Create < Requester::Action
        include Deps["inventory.operations.request_certificate"]

        params do
          required(:certificate).hash do
            required(:organization_unit).filled(:string)
            required(:owner).filled(:string)
            required(:email).filled(:string)

            required(:environment).filled(:string, included_in?: Hanami.app[:settings].environments)
            required(:application).filled(:string)

            required(:template).filled(:string)
            required(:key_size).filled(:integer)
            required(:common_name).filled(:string)
            required(:dns_records).array(:string)

            required(:host).filled(:string)
            required(:ip_addresses).array(:string)

            required(:install_method).filled(:string)
            required(:reference_id).maybe(:string)
          end
        end

        protected

        def handle_request(request) =
          request_certificate.call(request.params[:certificate])

        def success_status(result) = :created # 201
      end
    end
  end
end
