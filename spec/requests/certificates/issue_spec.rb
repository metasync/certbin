# frozen_string_literal: true

require 'base64'
require 'pathname'

RSpec.describe 'PUT /issuer/certificates/:id/issue', type: %i[request database] do
  context 'when given valid params' do
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

    it 'issues a requested certificate' do
      put "/issuer/certificates/#{id}/issue", params.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['certificate_content']).to eq(certificate_pfx)
      expect(certificate['serial_number']).to eq('1')
      expect(certificate['issued_on']).to eq('2012-04-27 10:31:18 +0000')
      expect(certificate['expires_on']).to eq('2022-04-25 10:31:18 +0000')
      expect(certificate['issuer']).to eq(
        'emailAddress=contact@freelan.org,CN=Freelan Sample Certificate Authority,OU=freelan,O=www.freelan.org,L=Strasbourg,ST=Alsace,C=FR'
      )
      expect(certificate['status']).to eq('issued')
      expect(certificate['issued_at']).to be <= Time.now.to_s
    end

    it 'issues a renewing certificate' do
      cert_repo.update(id, status: 'renewing')
      put "/issuer/certificates/#{id}/issue", params.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['certificate_content']).to eq(certificate_pfx)
      expect(certificate['status']).to eq('issued')
      expect(certificate['renewed_at']).to be <= Time.now.to_s
    end

    it 'issues an nonexistent certificate' do
      put "/issuer/certificates/#{nonexistent_id}/issue", params.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end

  context 'when given missing certificate content' do
    let(:invalid_params) do
      {
        certificate_pfx: nil,
        certificate_crt: nil
      }
    end

    it 'returns 422 unprocessable' do
      put "/issuer/certificates/#{id}/issue", invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
    end
  end

  context 'when given invalid certificate content' do
    let(:invalid_params) do
      {
        certificate_pfx: '1234567890',
        certificate_crt: '1234567890'
      }
    end

    it 'returns 422 unprocessable' do
      put "/issuer/certificates/#{id}/issue", invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result['error']).not_to be_nil
    end
  end
end
