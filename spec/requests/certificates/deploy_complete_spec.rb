# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/deploy_complete', type: %i[request database] do
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

    it 'deploys a certificate without any renewed certificates' do
      cert_repo.update(id,
                       status: 'issued',
                       issued_at: Time.now)

      put "/deployer/certificates/#{id}/deploy_complete", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('deployed')
      expect(certificate['deployed_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('deploy_certificate_complete')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('deployed')
      expect(changes['deployed_at']).to eq(certificate['deployed_at'])
    end

    it 'deploys a certificate with a renewed certificate' do
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

      put "/deployer/certificates/#{certificate['id']}/deploy_complete", {}.to_json, request_headers
      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)

      expect(certificate['id']).to eq(last_cert['next_certificate_id'])
      expect(certificate['status']).to eq('deployed')
      expect(certificate['deployed_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(certificate['id']).last
      expect(audit_log.certificate_id).to eq(certificate['id'])
      expect(audit_log.action).to eq('deploy_certificate_complete')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('deployed')
      expect(changes['deployed_at']).to eq(certificate['deployed_at'])

      last_cert = cert_repo.find(id)
      expect(last_cert.id).to eq(certificate['last_certificate_id'])
      expect(last_cert.status).to eq('expired')

      audit_log = audit_log_repo.find_by_certificate_id(last_cert.id).last
      expect(audit_log.certificate_id).to eq(last_cert.id)
      expect(audit_log.action).to eq('expire_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('expired')
      expect(changes['expired_at']).to eq(last_cert.expired_at.strftime('%Y-%m-%d %T %z'))
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
