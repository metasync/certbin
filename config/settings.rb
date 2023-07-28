# frozen_string_literal: true

require 'openssl'

module Certbin
  class Settings < Hanami::Settings
    setting :database_url, constructor: Types::String
    setting :db_user, constructor: Types::String
    setting :db_password, constructor: Types::String
    setting :environments, constructor: ->(v) { Types.Array(Types::String).call(v.split(/,\s*/)) }
    setting :cert_templates, constructor: ->(v) { Types.Array(Types::String).call(v.split(/,\s*/)) }
    setting :organization, constructor: Types::String
    setting :locality, constructor: Types::String
    setting :state_or_province, constructor: Types::String
    setting :country, constructor: Types::String
    setting :days_before_renewal, constructor: Types::Coercible::Integer
    setting :days_before_retirement, constructor: Types::Coercible::Integer
    setting :auth_token_algorithm, default: 'RS256', constructor: Types::String
    setting :auth_token_required_claims, constructor: ->(v) { Types.Array(Types::String).call(v.split(/,\s*/)) }
    setting :auth_token_issuers, constructor: ->(v) { Types.Array(Types::String).call(v.split(/,\s*/)) }
  end
end
