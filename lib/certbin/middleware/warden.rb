# frozen_string_literal: true

require 'dry-configurable'

require_relative 'warden/authorization'
require_relative 'warden/auth'

module Certbin
  module Middleware
    module Warden
      class Error < StandardError; end
      ConfigurationError = Class.new(Error)

      extend Dry::Configurable

      setting :authorize_by_default, default: true, constructor: Types::Bool
      setting :algorithm, default: 'RS256', constructor: Types::String
      setting :required_claims, default: %w[iss exp iat], constructor: Types.Array(Types::String)
      setting :issuers, default: [], constructor: Types.Array(Types::String)
    end
  end
end
