# frozen_string_literal: true

module Certbin
  class Routes < Hanami::Routes
    root { "Weclome to Certbin version #{Certbin::App::VERSION}" }
    get '/health/liveness', to: 'health.liveness.index'

    slice :inventory, at: '/inventory' do
    end

    slice :requester, at: '/' do
      post '/certificates', to: 'certificates.create'
      put '/certificates/:id/cancel', to: 'certificates.cancel'

      get '/certificates/common_name/:value', to: 'certificates.find_by_common_name'
      get '/certificates/ip_address/:value', to: 'certificates.find_by_ip_address'
      get '/certificates/status/:value', to: 'certificates.find_by_status'
      get '/certificates/host/:value', to: 'certificates.find_by_host'
      get '/certificates/dns_record/:value', to: 'certificates.find_by_dns_record'
      get '/certificates/id/:id', to: 'certificates.show'

      get '/certificates/retirable', to: 'certificates.find_retirable'
      get '/certificates/expirable', to: 'certificates.find_expirable'
      get '/certificates/expires_in/:days', to: 'certificates.find_expires_in'
      get '/certificates/requested', to: 'certificates.find_requested'
      get '/certificates/issued', to: 'certificates.find_issued'
      get '/certificates/deployed', to: 'certificates.find_deployed'
      get '/certificates/renewable', to: 'certificates.find_renewable'
      get '/certificates/renewing', to: 'certificates.find_renewing'
      get '/certificates/revoking', to: 'certificates.find_revoking'
      get '/certificates/revoked', to: 'certificates.find_revoked'
      get '/certificates/withdrawable', to: 'certificates.find_revoked'
    end

    slice :issuer, at: '/issuer' do
      get '/certificates/:id/cert_request', to: 'certificates.show_certificate_request'
      get '/certificates/:id/cert_content', to: 'certificates.show_certificate_content'
      put '/certificates/:id/issue', to: 'certificates.issue'
      put '/certificates/:id/renew', to: 'certificates.renew'
      put '/certificates/:id/revoke', to: 'certificates.revoke'
      put '/certificates/:id/revoke_complete', to: 'certificates.revoke_complete'
      put '/certificates/:id/expire', to: 'certificates.expire'
    end

    slice :deployer, at: '/deployer' do
      put '/certificates/:id/deploy_complete', to: 'certificates.deploy_complete'
      put '/certificates/:id/retire', to: 'certificates.retire'
      put '/certificates/:id/withdraw', to: 'certificates.withdraw'
    end
  end
end
