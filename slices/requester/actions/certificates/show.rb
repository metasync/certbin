# frozen_string_literal: true

# require "rom"

module Requester
  module Actions
    module Certificates
      class Show < Requester::Action
        params do
          required(:id).value(:integer)
        end

        protected

        def handle_request(request) =
          find_certificates.by_id(request.params[:id])
      end
    end
  end
end
