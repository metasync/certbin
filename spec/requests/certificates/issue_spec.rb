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

    it 'issues a requested certificate without any renewing certificates' do
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

      audit_log = audit_log_repo.find_by_certificate_id(certificate['id']).last
      expect(audit_log.certificate_id).to eq(certificate['id'])
      expect(audit_log.action).to eq('issue_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('issued')
      expect(changes['issued_at']).to eq(certificate['issued_at'])
    end

    it 'issues a requested certificate with a renewing certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))
      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers
      expect(last_response).to be_ok

      last_cert = JSON.parse(last_response.body)

      put "/issuer/certificates/#{last_cert['next_certificate_id']}/issue", params.to_json, request_headers
      expect(last_response).to be_ok
      certificate = JSON.parse(last_response.body)

      expect(certificate['id']).to eq(last_cert['next_certificate_id'])
      expect(certificate['certificate_content']).to eq(certificate_pfx)
      expect(certificate['serial_number']).to eq('1')
      expect(certificate['issued_on']).to eq('2012-04-27 10:31:18 +0000')
      expect(certificate['expires_on']).to eq('2022-04-25 10:31:18 +0000')
      expect(certificate['issuer']).to eq(
        'emailAddress=contact@freelan.org,CN=Freelan Sample Certificate Authority,OU=freelan,O=www.freelan.org,L=Strasbourg,ST=Alsace,C=FR'
      )
      expect(certificate['status']).to eq('issued')
      expect(certificate['issued_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(certificate['id']).last
      expect(audit_log.certificate_id).to eq(certificate['id'])
      expect(audit_log.action).to eq('issue_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('issued')
      expect(changes['issued_at']).to eq(certificate['issued_at'])

      last_cert = cert_repo.find(id)
      expect(last_cert.id).to eq(certificate['last_certificate_id'])
      expect(last_cert.status).to eq('renewed')

      audit_log = audit_log_repo.find_by_certificate_id(last_cert.id).last
      expect(audit_log.certificate_id).to eq(last_cert.id)
      expect(audit_log.action).to eq('renew_certificate_complete')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('renewed')
      expect(changes['renewed_at']).to eq(last_cert.renewed_at.strftime('%Y-%m-%d %T %z'))
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
