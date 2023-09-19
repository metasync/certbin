# frozen_string_literal: true

require 'elastic-apm'

module Certbin
  class Routes < Hanami::Routes
    root { "Weclome to Certbin version #{Certbin::App::VERSION}" }
    # get '/health/liveness', to: 'health.liveness.index'

    slice :inventory, at: '/inventory' do
    end

    slice :requester, at: '/certificates' do
      use Middleware::Warden::Authorization
      use ElasticAPM::Middleware

      post '/', to: 'certificates.create'
      put '/:id/cancel', to: 'certificates.cancel'

      get '/common_name/:value', to: 'certificates.find_by_common_name'
      get '/ip_address/:value', to: 'certificates.find_by_ip_address'
      get '/status/:value', to: 'certificates.find_by_status'
      get '/host/:value', to: 'certificates.find_by_host'
      get '/dns_record/:value', to: 'certificates.find_by_dns_record'
      get '/id/:id', to: 'certificates.show'

      get '/retirable', to: 'certificates.find_retirable'
      get '/expirable', to: 'certificates.find_expirable'
      get '/expires_in/:days', to: 'certificates.find_expires_in'
      get '/requested', to: 'certificates.find_requested'
      get '/issued', to: 'certificates.find_issued'
      get '/deployed', to: 'certificates.find_deployed'
      get '/renewable', to: 'certificates.find_renewable'
      get '/renewing', to: 'certificates.find_renewing'
      get '/revoking', to: 'certificates.find_revoking'
      get '/revoked', to: 'certificates.find_revoked'
      get '/withdrawable', to: 'certificates.find_revoked'
    end

    slice :issuer, at: '/issuer/certificates' do
      use Middleware::Warden::Authorization
      use ElasticAPM::Middleware

      get '/:id/cert_request', to: 'certificates.show_certificate_request'
      get '/:id/cert_content', to: 'certificates.show_certificate_content'
      put '/:id/issue', to: 'certificates.issue'
      put '/:id/renew', to: 'certificates.renew'
      put '/:id/revoke', to: 'certificates.revoke'
      put '/:id/revoke_complete', to: 'certificates.revoke_complete'
      put '/:id/expire', to: 'certificates.expire'
    end

    slice :deployer, at: '/deployer/certificates' do
      use Middleware::Warden::Authorization
      use ElasticAPM::Middleware

      put '/:id/deploy_complete', to: 'certificates.deploy_complete'
      put '/:id/retire', to: 'certificates.retire'
      put '/:id/withdraw', to: 'certificates.withdraw'
    end

    slice :auditor, at: '/auditor/audit_logs' do
      use Middleware::Warden::Authorization
      use ElasticAPM::Middleware

      get '/certificate/:value', to: 'audit_logs.find_by_certificate_id'
      get '/first_certificate/:value', to: 'audit_logs.find_by_first_certificate_id'
      get '/action/:value', to: 'audit_logs.find_by_action'
      get '/actioned_by/:value', to: 'audit_logs.find_by_actioned_by'
      get '/action_group/:value', to: 'audit_logs.find_by_action_group'
    end

    slice :health, at: '/health' do
      use ElasticAPM::Middleware

      get '/liveness', to: 'liveness.index'
    end
  end
end
