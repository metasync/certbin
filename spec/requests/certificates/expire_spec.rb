# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/expire', type: %i[request database] do
  context 'when given valid params' do
    it 'expires an issued certificate' do
      cert_repo.update(id,
                       status: 'issued',
                       issued_at: Time.now - (24 * 60 * 60),
                       expires_on: Time.now - (60 * 60))

      put "/issuer/certificates/#{id}/expire", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('expired')

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('expire_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('expired')
      expect(changes['expired_at']).to eq(certificate['expired_at'])
    end

    it 'expires a deployed certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now - (24 * 60 * 60),
                       expires_on: Time.now - (60 * 60))

      put "/issuer/certificates/#{id}/expire", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('expired')

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('expire_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('expired')
      expect(changes['expired_at']).to eq(certificate['expired_at'])
    end

    it 'expires a non-expiring certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + (24 * 60 * 60))

      put "/issuer/certificates/#{id}/expire", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['expires_on'].first).to eq('is NOT yet reached')
    end

    it 'expires a certificate from wrong status' do
      put "/issuer/certificates/#{id}/expire", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq('must be "deployed", "issued" or "renewed"')
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/issuer/certificates/#{nonexistent_id}/expire", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
