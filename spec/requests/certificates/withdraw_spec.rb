# frozen_string_literal: true

RSpec.describe 'PUT /deployer/certificates/:id/withdraw', type: %i[request database] do
  context 'when given valid params' do
    it 'revokes a certificate' do
      cert_repo.update(id,
                       status: 'revoked',
                       revoked_at: Time.now)

      put "/deployer/certificates/#{id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('withdrawn')
      expect(certificate['withdrawn_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('withdraw_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('withdrawn')
      expect(changes['withdrawn_at']).to eq(certificate['withdrawn_at'])
    end

    it 'revokes a certificate from a wrong status' do
      put "/deployer/certificates/#{id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      certificate = JSON.parse(last_response.body)
      expect(certificate['status'].first).to eq('must be "revoked"')
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/deployer/certificates/#{nonexistent_id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
