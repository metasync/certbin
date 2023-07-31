# frozen_string_literal: true

Hanami.app.register_provider :warden, namespace: true do
  start do
    Certbin::Middleware::Warden.configure do |config|
      config.algorithm = target['settings'].auth_token_algorithm
      config.required_claims = target['settings'].auth_token_required_claims
      config.issuers = target['settings'].auth_token_issuers
      config.authorize_by_default = target['settings'].authorize_by_default
    end
  end
end
