# frozen_string_literal: true

RSpec.describe 'PUT /deployer/certificates/:id/retire', type: %i[request database] do
  context 'when given valid params' do
    it 'retires a certificate' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now - ((app.settings.days_before_retirement + 1) * 24 * 60 * 60))

      put "/deployer/certificates/#{id}/retire", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('retired')
      expect(certificate['retired_at']).to be <= Time.now.to_s

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('retire_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('retired')
      expect(changes['retired_at']).to eq(certificate['retired_at'])
    end

    it 'retires a certificate that is expred recently' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now - (60 * 60))

      put "/deployer/certificates/#{id}/retire", {}.to_json, request_headers

      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq("must be \"expired\" over #{app.settings.days_before_retirement} days")
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/deployer/certificates/#{nonexistent_id}/retire", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
