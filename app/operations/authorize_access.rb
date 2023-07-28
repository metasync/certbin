# frozen_string_literal: true

require 'dry/monads'

module Certbin
  module Operations
    class AuthorizeAccess
      include Dry::Monads[:result]

      include Deps['settings']

      InvalidTokenError = Class.new(StandardError)

      def call(request)
        auth_header = request.env['HTTP_AUTHORIZATION']
        return Failure(InvalidTokenError.new('Unauthorized. Authorization header is missing!')) if auth_header_missing?(auth_header)

        auth_token = extract_auth_token(auth_header)
        return Failure(InvalidTokenError.new('Unauthorized. Authorization token is missing!')) if auth_token_missing?(auth_token)

        Success(decode(auth_token)[0]) # Only payload is returned
      rescue JWT::DecodeError => e
        Failure(InvalidTokenError.new("Unauthorized. Authorization token is INVALID - #{e.message}"))
      end

      protected

      def auth_header_missing?(auth_header) = auth_header.nil? || auth_header.empty?

      def auth_token_missing?(auth_token) = auth_token.nil? || auth_token.empty?

      def extract_auth_token(http_authorization) =
        http_authorization.to_s.gsub('Bearer ', '')

      def decode(auth_token)
        JWT.decode(auth_token, nil, true,
                   {
                     iss: settings.auth_token_issuers,
                     verify_iss: true,
                     verify_iat: true,
                     required_claims: settings.auth_token_required_claims,
                     algorithm: settings.auth_token_algorithm
                   },
                   &method(:find_key))
      end

      def find_key(_headers, payload)
        base_path = File.expand_path('../../authorized_keys', __dir__)
        public_key_file = File.join(base_path, "#{payload['iss']}.pub")
        return unless File.file?(public_key_file)

        OpenSSL::PKey::RSA.new File.binread(public_key_file)
      end
    end
  end
end
