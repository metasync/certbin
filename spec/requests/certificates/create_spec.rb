# frozen_string_literal: true

RSpec.describe 'POST /certificates', type: %i[request database] do
  let(:params) do
    {
      certificate: {
        organization_unit: 'IT Dev',
        organization: 'Example Company Limited',
        locality: 'Macau',
        state_or_province: 'Macau',
        country: 'CN',

        owner: 'App Support',
        email: 'app_support@company.com',

        environment: 'prd',
        application: 'example',

        template: 'webserver',
        key_size: 4096,
        common_name: 'example.company.com',
        dns_records: [
          'example.company.com',
          'example'
        ],
        ip_addresses: ['233.233.233.233'],
        host: 'prd-example-01',
        install_method: 'OCP', # Windows / IIS / Manual
        reference_id: '1234567890'
      }
    }
  end

  context 'when given valid params' do
    it 'creates a certificate' do
      post '/certificates', params.to_json, request_headers

      expect(last_response).to be_created
      certificate = JSON.parse(last_response.body)
      # puts JSON.pretty_generate(certificate)
      expect(certificate['first_certificate_id']).to eq(certificate['id'])

      audit_log = audit_log_repo.find_by_certificate_id(certificate['id']).first
      expect(audit_log.certificate_id).to eq(certificate['id'])
      expect(audit_log.action).to eq('request_certificate')
      expect(audit_log.actioned_by).to eq(test_auth_token[:payload][:data][:user])
      expect(audit_log.action_group).to eq(test_auth_token[:payload][:iss])
      changes = JSON.parse(audit_log.changes)
      changes.each_pair do |key, value|
        expect(value).to eq(certificate[key]) unless %w[dns_records ip_addresses].include?(key)
      end
    end
  end

  context 'when given invalid params' do
    it 'returns 422 unprocessable' do
      invalid_params = params.tap do |p|
        p[:certificate][:organization_unit] = nil
      end
      post '/certificates', invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
      # errors = JSON.parse(last_response.body)
    end
  end

  context 'when given invalid params - cert template' do
    it 'returns 422 unprocessable' do
      invalid_params = params.tap do |p|
        p[:certificate][:template] = 'undefined_template'
      end
      post '/certificates', invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
      # errors = JSON.parse(last_response.body)
    end
  end
end
