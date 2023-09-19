# frozen_string_literal: true

module Health
  module Actions
    module Liveness
      class Index < Health::Action
        include Deps['operations.check_database_connection']

        protected

        def handle_request(_request) = check_database_liveness

        def success_body(result) = result.to_json
        def error_status(_result) = :internal_server_error

        def check_database_liveness
          if check_database_connection.call
            Hanami.app['logger'].info 'Database connection is OK.'
            { status: 'ok' }
          else
            Hanami.app['logger'].error 'Database connection is lost.'
            { error: { database: 'Connection is lost.' } }
          end
        end
      end
    end
  end
end
