# frozen_string_literal: true

require 'openssl'
require 'jwt'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed

  def sample_certificate_id = @id
  def test_auth_token = @auth_token

  config.before do
    @id = cert_repo.create(sample_cert).id

    @auth_token = {
      issuer: 'devops',
      private_key: OpenSSL::PKey::RSA.generate(4096),
      algorithm: 'RS256',
      expires_in: 5 # min
    }
    @auth_token[:payload] = {
      iss: @auth_token[:issuer],
      iat: Time.now.to_i,
      exp: Time.now.to_i + (@auth_token[:expires_in] * 60)
    }
    @auth_token[:value] = JWT.encode(
      @auth_token[:payload],
      @auth_token[:private_key],
      @auth_token[:algorithm]
    )
    base_path = File.expand_path('../../authorized_keys', __dir__)
    private_key_file = File.join(base_path, "#{@auth_token[:issuer]}.priv")
    public_key_file = File.join(base_path, "#{@auth_token[:issuer]}.pub")
    File.write(private_key_file, @auth_token[:private_key].to_pem)
    File.write(public_key_file, @auth_token[:private_key].public_to_pem)
  end

  config.after do
    cert_repo.delete(@id)
  end
end
