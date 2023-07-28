# frozen_string_literal: true

RSpec.describe 'GET /health/liveness', type: :request do
  context 'when given no authorization header' do
    let(:authorization_token) do
      test_auth_token.tap { |t| t[:value] = nil }
    end

    it 'gives error of missing authorization header' do
      get "/certificates/id/#{id}"
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/Authorization header is missing/)
    end

    it 'gives error of missing token' do
      get "/certificates/id/#{id}", {}.to_json, request_headers
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/Authorization token is missing/)
    end
  end

  context 'when given no issuer in auth token' do
    let(:authorization_token) do
      test_auth_token.tap do |t|
        t[:value] = JWT.encode(
          {},
          test_auth_token[:private_key],
          test_auth_token[:algorithm]
        )
      end
    end

    it 'gives error of no verification key available' do
      get "/certificates/id/#{id}", {}.to_json, request_headers
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/No verification key available/)
    end
  end

  context 'when given invalid issuer in auth token' do
    let(:authorization_token) do
      test_auth_token.tap do |t|
        t[:value] = JWT.encode(
          { iss: 'abc' },
          test_auth_token[:private_key],
          test_auth_token[:algorithm]
        )
      end
    end

    it 'gives error of no verification key available' do
      get "/certificates/id/#{id}", {}.to_json, request_headers
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/No verification key available/)
    end
  end

  context 'when given no issued at' do
    let(:authorization_token) do
      test_auth_token.tap do |t|
        t[:value] = JWT.encode(
          {
            iss: test_auth_token[:issuer],
            exp: Time.now.to_i + (test_auth_token[:expires_in] * 60)
          },
          test_auth_token[:private_key],
          test_auth_token[:algorithm]
        )
      end
    end

    it 'gives error of missing required claim iat' do
      get "/certificates/id/#{id}", {}.to_json, request_headers
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/Missing required claim iat/)
    end
  end

  context 'when given no expires in' do
    let(:authorization_token) do
      test_auth_token.tap do |t|
        t[:value] = JWT.encode(
          {
            iss: test_auth_token[:issuer],
            iat: Time.now.to_i
          },
          test_auth_token[:private_key],
          test_auth_token[:algorithm]
        )
      end
    end

    it 'gives error of missing required claim exp' do
      get "/certificates/id/#{id}", {}.to_json, request_headers
      expect(last_response.status).to eq(401)

      result = JSON.parse(last_response.body)
      expect(result['error']).to match(/Missing required claim exp/)
    end
  end
end
