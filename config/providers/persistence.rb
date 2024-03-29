# frozen_string_literal: true

Hanami.app.register_provider :persistence, namespace: true do
  prepare do
    require 'rom'

    config = ROM::Configuration.new(
      :sql, target['settings'].database_url,
      username: target['settings'].db_user,
      password: target['settings'].db_password
    )

    register 'config', config
    register 'db', config.gateways[:default].connection
  end

  start do
    config = target['persistence.config']

    config.auto_registration(
      target.root.join('lib/certbin/persistence'),
      namespace: 'Certbin::Persistence'
    )

    register 'rom', ROM.container(config)
  end
end
