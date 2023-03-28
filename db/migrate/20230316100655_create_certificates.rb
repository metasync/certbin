# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :certificates do
      primary_key :id, type: :Bignum
      String :status, null: false

      String :organization_unit, null: false
      String :organization, null: false
      String :locality, null: false
      String :state_or_province, null: false
      String :country, null: false

      String :owner, null: false
      String :email, null: false

      String :environment, null: false
      String :application, null: false

      String :template, null: false
      Integer :key_size, null: false
      String :common_name, null: false

      String :host, null: false

      String :install_method, null: false
      String :reference_id

      String :serial_number
      Datetime :issued_on
      Datetime :expires_on
      String :issuer
      String :certificate_content, text: true

      Datetime :requested_at, null: false
      Datetime :cancelled_at
      Datetime :issued_at
      Datetime :deployed_at
      Datetime :renewed_at
      Datetime :expired_at
      Datetime :revoked_at
      Datetime :withdrawn_at
      Datetime :retired_at

      String :remarks

      Datetime :created_at, null: false
      Datetime :updated_at, null: false

      index [:owner, :environment, :status], name: "certman_certs_owner_env_status"
      index [:environment, :status], name: "certman_certs_env_status"
      index [:application, :environment, :status], name: "certman_certs_app_env_status"
      index :common_name
      index :host
      index :serial_number
      index :status
      index [:expires_on, :status, :environment], name: "certman_certs_exp_on_status_env"
    end
  end
end
