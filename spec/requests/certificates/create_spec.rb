# frozen_string_literal: true

RSpec.describe 'POST /certificates', type: %i[request database] do
  let(:request_headers) do
    { 'HTTP_ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end

  context 'when given valid params' do
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

    it 'creates a certificate' do
      post '/certificates', params.to_json, request_headers

      expect(last_response).to be_created
      certificate = JSON.parse(last_response.body)
      # puts JSON.pretty_generate(certificate)
      cert_repo.delete(certificate['id'])
    end
  end

  context 'when given invalid params' do
    let(:params) do
      { certificate: { organization_unit: nil } }
    end

    it 'returns 422 unprocessable' do
      post '/certificates', params.to_json, request_headers

      expect(last_response).to be_unprocessable
      # errors = JSON.parse(last_response.body)
    end
  end
end
