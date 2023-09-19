# frozen_string_literal: true

require 'hanami/boot'
require 'elastic-apm'

ElasticAPM.start(
  service_name: ENV.fetch('ELASTIC_APM_SERVICE_NAME', Hanami.app.app_name.name),
  framework_name: 'Hanami',
  framework_version: Hanami::VERSION
)

run Hanami.app

at_exit { ElasticAPM.stop }
