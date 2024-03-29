# frozen_string_literal: true

require 'base64'

RSpec.describe 'GET /issuer/certificates/:id/cert_content', type: :request do
  context 'when given a certificate to show certificate content' do
    let(:certificate_pfx) do
      Base64.encode64(
        File.read(File.join(__dir__, '../../support/certificates/alice.pfx'))
      )
    end

    let(:certificate_crt) do
      Base64.encode64(
        File.read(File.join(__dir__, '../../support/certificates/alice.crt'))
      )
    end

    let(:params) do
      {
        certificate_pfx:,
        certificate_crt:
      }
    end

    it 'return certificate content' do
      put "/issuer/certificates/#{id}/issue", params.to_json, request_headers
      expect(last_response).to be_successful

      get "/issuer/certificates/#{id}/cert_content", {}.to_json, request_headers

      expect(last_response).to be_successful

      certificate = JSON.parse(last_response.body)

      expect(certificate['id']).to eq(id)
      expect(certificate['cert_content']).to eq(certificate_pfx)
      # puts certificate["cert_content"]
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
end
