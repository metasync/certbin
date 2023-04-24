# frozen_string_literal: true

module Deployer
  module Actions
    module Certificates
      class Retire < Deployer::Action
        include Deps['inventory.operations.retire_certificate']

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          retire_certificate.call(request.params[:id])
      end
    end
  end
end
