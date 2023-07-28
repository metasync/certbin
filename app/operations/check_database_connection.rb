# frozen_string_literal: true

module Certbin
  module Operations
    class CheckDatabaseConnection
      include Deps['settings']

      def call = valid_connection?

      protected

      def valid_connection?
        db = Hanami.app['persistence.db']
        db.synchronize do |connection|
          db.valid_connection?(connection)
        end
      end
    end
  end
end
