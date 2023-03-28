# frozen_string_literal: true

module Requester
  module Actions
    module Certificates
      class FindExpiresIn < FindByCategory
        params do
          required(:days).filled(:integer)
        end

        protected

        def find(params) =
          find_certificates.expires_in(params[:days])
      end
    end
  end
end
