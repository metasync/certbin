# frozen_string_literal: true

module Certman
  module Actions
    module Health
      module Liveness
        class Index < Certman::Action
          def handle(*, response)
            response.body = {status: "ok"}.to_json
          end
        end
      end
    end
  end
end
