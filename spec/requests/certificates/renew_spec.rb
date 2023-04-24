# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/renew', type: %i[request database] do
  let(:request_headers) do
    { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end

  context 'when given valid params' do
    it 'renews an expiring certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('renewing')
    end

    it 'renews an expired certificate' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now,
                       expires_on: Time.now)

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('renewing')
    end

    it 'renews a non-expiring certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal + 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq("must be \"expired\" or \"expiring\" in #{app.settings.days_before_renewal} days")
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/issuer/certificates/#{nonexistent_id}/renew", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
