# frozen_string_literal: true

module Deployer
  module Actions
    module Certificates
      class Withdraw < Deployer::Action
        include Deps['inventory.operations.withdraw_certificate']

        params do
          required(:id).filled(:integer)
        end

        protected

        def handle_request(request) =
          withdraw_certificate.call(request.params[:id])
      end
    end
  end
end
