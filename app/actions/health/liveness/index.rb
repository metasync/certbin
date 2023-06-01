# frozen_string_literal: true

module Certbin
  module Actions
    module Health
      module Liveness
        class Index < Certbin::Action
          def handle(*, response)
            response.body = { status: 'ok' }.to_json
          end
        end
      end
    end
  end
end
