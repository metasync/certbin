# frozen_string_literal: true

module Certbin
  module Actions
    module Health
      module Liveness
        class Index < Certbin::Action
          include Deps['operations.check_database_connection']

          protected

          def handle_request(request) = check_database_liveness

          def success_body(result) = result.to_json
          def error_status(_result) = :service_unavailable

          def check_database_liveness
            if !check_database_connection.call
              Hanami.app['logger'].error "Database connection is lost."
              { error: 
                  { database: 'Connection is lost.' }
              }
            else
              Hanami.app['logger'].info "Database connection is OK."
              { status: 'ok' }
            end
          end
        end
      end
    end
  end
end
