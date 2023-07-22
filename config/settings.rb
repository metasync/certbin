# frozen_string_literal: true

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
  end
end
