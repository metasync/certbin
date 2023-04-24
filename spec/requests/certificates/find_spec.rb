# frozen_string_literal: true

RSpec.describe 'GET /certificates', type: :request do
  let(:common_name) { 'example.company.com' }
  let(:ip_address) { '233.233.233.233' }
  let(:dns_record) { 'example.company.com' }
  let(:status) { 'requested' }
  let(:host) { 'prd-example-01' }
  let(:days_before_expire) { 1 }

  context 'when given a common name to find certificates' do
    it 'returns certificates with the given common name' do
      get "/certificates/common_name/#{common_name}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['common_name']).to eq(common_name)
      end
    end
  end

  context 'when givne an ip address to find certificates by' do
    it 'returns certificates with the given ip address' do
      get "/certificates/ip_address/#{ip_address}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['ip_addresses'].map do |ip_address|
          ip_address['value']
        end).to include(ip_address)
      end
    end
  end

  context 'when given a dns record to find certificates' do
    it 'returns certificates with the given dns record' do
      get "/certificates/dns_record/#{dns_record}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['dns_records'].map do |dns_record|
          dns_record['value']
        end).to include(dns_record)
      end
    end
  end

  context 'when givne a status to find certificates' do
    it 'returns certificates with the given status' do
      get "/certificates/status/#{status}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq(status)
      end
    end
  end

  context 'when given a host to find certificates' do
    it 'returns certificates with the given host' do
      get "/certificates/host/#{host}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['host']).to eq(host)
      end
    end
  end

  context 'when given an id to find certificates' do
    it 'returns certificates with the given id' do
      get "/certificates/id/#{id}"

      expect(last_response).to be_successful

      certificate = JSON.parse(last_response.body)
      expect(certificate['id']).to eq(id)
    end

    it 'returns 422 unprocessable' do
      get '/certificates/id/abc'

      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result['id'].first).to eq('must be an integer')
    end
  end

  context 'when given a non-existent id to find certificates' do
    it 'returns 404 not found' do
      get "/certificates/id/#{nonexistent_id}"

      expect(last_response).to be_not_found

      result = JSON.parse(last_response.body)
      expect(result['error']).to eq('Certificate is NOT found.')
    end

    it 'returns 422 unprocessable' do
      get '/certificates/id/abc'

      expect(last_response).to be_unprocessable
    end
  end

  context 'when requested to find retirable certificates' do
    it 'returns retirable certificates' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now - ((app.settings.days_before_retirement + 1) * 24 * 60 * 60))

      get '/certificates/retirable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      expires_after = Time.now - (Hanami.app['settings'].days_before_retirement * 24 * 60 * 60)
      certificates.each do |certificate|
        expect(certificate['status']).to eq('expired')
        expect(certificate['expired_at']).to be <= expires_after.to_s
      end
    end
  end

  context 'when requested to find withdrawable certificates' do
    it 'returns withdrawable certificates' do
      cert_repo.update(id,
                       status: 'revoked',
                       revoked_at: Time.now)

      get '/certificates/withdrawable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('revoked')
      end
    end
  end

  context 'when requested to find expirable certificates' do
    it 'returns expirable deployed certificates' do
      cert_repo.update(id,
                       status: 'deployed',
                       expires_on: Time.now - (60 * 60))

      get '/certificates/expirable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('deployed')
        expect(certificate['expires_on']).to be <= Time.now.to_s
      end
    end

    it 'returns expirable issued certificates' do
      cert_repo.update(id,
                       status: 'issued',
                       expires_on: Time.now - (60 * 60))

      get '/certificates/expirable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('issued')
        expect(certificate['expires_on']).to be <= Time.now.to_s
      end
    end
  end

  context 'when requested to find certificates that expire in given days' do
    it 'returns expirable certificates that expire in given days' do
      cert_repo.update(id,
                       status: 'deployed',
                       expires_on: Time.now + (12 * 60 * 60))

      get "/certificates/expires_in/#{days_before_expire}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('issued').or eq('deployed')
        expect(certificate['expires_on']).to be <= (Time.now + (days_before_expire * 24 * 60 * 60)).to_s
        expect(certificate['expires_on']).to be > Time.now.to_s
      end
    end
  end

  context 'when requested to find requested certificates' do
    it 'returns requested certificates' do
      get '/certificates/requested'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('requested')
      end
    end
  end

  context 'when requested to find issued certificates' do
    it 'returns issued certificates' do
      cert_repo.update(id,
                       status: 'issued',
                       issued_at: Time.now)

      get '/certificates/issued'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('issued')
      end
    end
  end

  context 'when requested to find deployed certificates' do
    it 'returns deployed certificates' do
      cert_repo.update(id,
                       status: 'deployed',
                       deployed_at: Time.now)

      get '/certificates/deployed'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('deployed')
      end
    end
  end

  context 'when requested to find renewing certificates' do
    it 'returns renewing certificates' do
      cert_repo.update(id,
                       status: 'renewing')

      get '/certificates/renewing'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('renewing')
      end
    end
  end

  context 'when requested to find revoking certificates' do
    it 'returns revoking certificates' do
      cert_repo.update(id,
                       status: 'revoking')

      get '/certificates/revoking'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('revoking')
      end
    end
  end

  context 'when requested to find revoked certificates' do
    it 'returns revoked certificates' do
      cert_repo.update(id,
                       status: 'revoked',
                       revoked_at: Time.now)

      get '/certificates/revoked'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('revoked')
      end
    end
  end

  context 'when requested to find renewable certificates' do
    it 'returns renewable deployed certificates' do
      cert_repo.update(id,
                       status: 'deployed',
                       expired_at: nil,
                       expires_on: Time.now + (24 * 60 * 60))

      get '/certificates/renewable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('deployed')
        expect(certificate['expires_on']).to be <= (Time.now + (days_before_expire * 24 * 60 * 60)).to_s
        expect(certificate['expires_on']).to be > Time.now.to_s
      end
    end

    it 'returns renewable expired certificates' do
      cert_repo.update(id,
                       status: 'expired',
                       expired_at: Time.now - (24 * 60 * 60))

      get '/certificates/renewable'

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate['status']).to eq('expired')
        expect(certificate['expired_at']).to be <= Time.now.to_s
      end
    end
  end
end
