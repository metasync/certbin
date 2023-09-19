# frozen_string_literal: true

require 'hanami/boot'
require 'elastic-apm'

ElasticAPM.start(
  service_name: Hanami.app.app_name.name,
  framework_name: 'Hanami',
  framework_version: Hanami::VERSION
)

run Hanami.app

at_exit { ElasticAPM.stop }
