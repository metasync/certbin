# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/revoke_complete', type: %i[request database] do
  context 'when given valid params' do
    it 'revokes a certificate complete' do
      cert_repo.update(id,
                       status: 'revoking')

      put "/issuer/certificates/#{id}/revoke_complete", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('revoked')
      expect(certificate['revoked_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('revoke_certificate_complete')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('revoked')
      expect(changes['revoked_at']).to eq(certificate['revoked_at'])
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/issuer/certificates/#{nonexistent_id}/revoke_complete", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
