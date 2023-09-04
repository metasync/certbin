# frozen_string_literal: true

RSpec.describe 'GET /auditor/audit_logs', type: :request do
  context 'when given a certificate id' do
    it 'returns audit logs for the given certificate' do
      put "/certificates/#{id}/cancel", {}.to_json, request_headers

      get "/auditor/audit_logs/certificate/#{id}", {}.to_json, request_headers
      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be >= 1
      expect(audit_logs.first['certificate_id']).to eq(id)
    end
  end

  context 'when given a first certificate id' do
    it 'returns audit logs for the given first certificate' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      get "/auditor/audit_logs/first_certificate/#{id}", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be >= 1
      audit_logs.each do |audit_log|
        expect(audit_log['first_certificate_id']).to eq(id)
      end
    end
  end

  context 'when given an action' do
    let(:action) { 'renew_certificate' }

    it 'returns audit logs for the given action' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      get "/auditor/audit_logs/action/#{action}", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be >= 1
      audit_logs.each do |audit_log|
        expect(audit_log['action']).to eq(action)
      end
    end
  end

  context 'when given an actioned_by' do
    let(:actioned_by) { 'tester' }

    it 'returns audit logs for the given actioned_by' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      get "/auditor/audit_logs/actioned_by/#{actioned_by}", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be >= 1
      audit_logs.each do |audit_log|
        expect(audit_log['actioned_by']).to eq(actioned_by)
      end
    end
  end

  context 'when given an action group' do
    let(:action_group) { 'devops' }

    it 'returns audit logs for the given action group' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      get "/auditor/audit_logs/action_group/#{action_group}", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be >= 1
      audit_logs.each do |audit_log|
        expect(audit_log['action_group']).to eq(action_group)
      end
    end
  end

  context 'when given an action group with limit and offset' do
    let(:action_group) { 'devops' }

    it 'returns audit logs for the given action group with limit and offset' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now,
                       expires_on: Time.now + ((app.settings.days_before_renewal - 1) * 24 * 60 * 60))

      put "/issuer/certificates/#{id}/renew", {}.to_json, request_headers

      get "/auditor/audit_logs/action_group/#{action_group}?limit=1", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be == 1
      audit_log = audit_logs.first
      expect(audit_log['action_group']).to eq(action_group)
      changes = JSON.parse(audit_log['changes'])
      expect(changes['status']).to eq('requested')

      get "/auditor/audit_logs/action_group/#{action_group}?limit=1&offset=1", {}.to_json, request_headers

      expect(last_response).to be_successful

      audit_logs = JSON.parse(last_response.body)
      expect(audit_logs.size).to be == 1
      audit_log = audit_logs.first
      expect(audit_log['action_group']).to eq(action_group)
      changes = JSON.parse(audit_log['changes'])
      expect(changes['status']).to eq('renewing')
    end
  end
end
