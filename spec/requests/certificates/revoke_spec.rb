# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/revoke', type: %i[request database] do
  context 'when given valid params' do
    it 'revokes an issued certificate' do
      cert_repo.update(id,
                       status: 'issued',
                       issued_at: Time.now)

      put "/issuer/certificates/#{id}/revoke", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('revoking')
    end

    it 'revokes deployed certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now)

      put "/issuer/certificates/#{id}/revoke", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['status']).to eq('revoking')
    end

    it 'revokes a certificate from wrong status' do
      put "/issuer/certificates/#{id}/revoke", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq('must be "deployed" or "issued"')
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/issuer/certificates/#{nonexistent_id}/revoke", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
