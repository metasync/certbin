# frozen_string_literal: true

RSpec.describe 'PUT /issuer/certificates/:id/renew', type: %i[request database] do
  context 'when given valid params' do
    it 'renews an expiring certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('renewing')
      expect(certificate['next_certificate_id']).not_to be_nil

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('renew_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('renewing')

      next_cert = cert_repo.find(certificate['next_certificate_id'])
      %w[organization_unit organization
         locality state_or_province country
         owner email
         environment application
         template key_size common_name
         install_method reference_id].each do |attr|
        expect(next_cert.send(attr)).to eq(certificate[attr])
      end
      expect(next_cert.first_certificate_id).to eq(certificate['first_certificate_id'])
      expect(next_cert.last_certificate_id).to eq(id)
      expect(next_cert.status).to eq('requested')

      audit_log = audit_log_repo.find_by_certificate_id(next_cert.id).first
      expect(audit_log.certificate_id).to eq(next_cert.id)
      expect(audit_log.action).to eq('request_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('requested')
      expect(changes['requested_at']).to eq(next_cert.requested_at.strftime('%Y-%m-%d %T %z'))
    end

    it 'renews an expired certificate' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now,
                       expires_on: Time.now)

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
      expect(certificate['status']).to eq('renewing')
      expect(certificate['next_certificate_id']).not_to be_nil

      audit_log = audit_log_repo.find_by_certificate_id(id).first
      expect(audit_log.certificate_id).to eq(id)
      expect(audit_log.action).to eq('renew_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('renewing')

      next_cert = cert_repo.find(certificate['next_certificate_id'])
      %w[organization_unit organization
         locality state_or_province country
         owner email
         environment application
         template key_size common_name

         install_method reference_id].each do |attr|
        expect(next_cert.send(attr)).to eq(certificate[attr])
      end
      expect(next_cert.first_certificate_id).to eq(certificate['first_certificate_id'])
      expect(next_cert.last_certificate_id).to eq(id)
      expect(next_cert.status).to eq('requested')

      audit_log = audit_log_repo.find_by_certificate_id(next_cert.id).first
      expect(audit_log.certificate_id).to eq(next_cert.id)
      expect(audit_log.action).to eq('request_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      expect(changes['status']).to eq('requested')
      expect(changes['requested_at']).to eq(next_cert.requested_at.strftime('%Y-%m-%d %T %z'))
    end

    it 'renews a non-expiring certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal + 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result['status'].first).to eq("must be \"expired\" or \"expiring\" in #{app.settings.days_before_renewal} days")
    end
  end

  context 'when given nonexistent certificate' do
    let(:nonexistent_id) { 10_000 }

    it 'returns error certificate not found' do
      put "/issuer/certificates/#{nonexistent_id}/renew", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
