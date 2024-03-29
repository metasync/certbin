# frozen_string_literal: true

RSpec.describe 'GET /issuer/certificates/:id/cert_request', type: :request do
  context 'when given a certificate to show certificate request' do
    it 'return certificate request' do
      get "/issuer/certificates/#{id}/cert_request", {}.to_json, request_headers

      expect(last_response).to be_successful

      certificate = JSON.parse(last_response.body)

      expect(certificate['id']).to eq(id)
      expect(certificate['cert_request']).not_to be_nil
    end
  end

  context 'when given a non-existent id to show certificate request' do
    it 'return error certificate not found' do
      get "/issuer/certificates/#{nonexistent_id}/cert_request", {}.to_json, request_headers

      expect(last_response).to be_not_found

      result = JSON.parse(last_response.body)
      expect(result['error']).to eq('Certificate is NOT found.')
    end
  end

  context 'when given a certificate with invalid cert template to show certificate request' do
    it 'return error invalid certificate request template' do
      cert_repo.update(id, template: 'web_server')

      get "/issuer/certificates/#{id}/cert_request", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['error']).to match('Certificate request template is INVALID')
    end
  end
end
