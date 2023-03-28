# frozen_string_literal: true

module Deployer
  module Actions
    module Certificates
      class DeployComplete < Deployer::Action
        include Deps["inventory.operations.deploy_certificate_complete"]

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          deploy_certificate_complete.call(
            request.params[:id]
          )
      end
    end
  end
end
