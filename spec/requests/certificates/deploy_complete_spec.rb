# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/deploy_complete', type: %i[request database] do
  let(:request_headers) do
    { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end

  context 'when given valid params' do
    it 'deploys a certificate' do
      cert_repo.update(id,
                       status: 'issued',
                       issued_at: Time.now)

      put "/deployer/certificates/#{id}/deploy_complete", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('deployed')
      expect(certificate['deployed_at']).to be <= Time.now.to_s
    end

    it 'deploys a certificate from a wrong status' do
      put "/deployer/certificates/#{id}/deploy_complete", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq('must be "issued"')
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/deployer/certificates/#{nonexistent_id}/deploy_complete", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
