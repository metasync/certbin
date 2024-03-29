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

      String :install_method, null: false
      String :reference_id

      String :serial_number
      DateTime :issued_on
      DateTime :expires_on
      String :issuer

      if ENV['DB_ADAPTER'] == 'tinytds'
        # Use VARCHAR(MAX) for SQL Server
        String :certificate_content, size: :max
      else
        # Use TEXT for other databases
        String :certificate_content, text: true
      end

      DateTime :requested_at, null: false
      DateTime :cancelled_at
      DateTime :issued_at
      DateTime :deployed_at
      DateTime :renewed_at
      DateTime :expired_at
      DateTime :revoked_at
      DateTime :withdrawn_at
      DateTime :retired_at

      String :remarks

      Bignum :first_certificate_id
      Bignum :next_certificate_id
      Bignum :last_certificate_id

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index %i[owner environment status], name: 'certbin_certs_owner_env_status'
      index %i[environment status], name: 'certbin_certs_env_status'
      index %i[application environment status], name: 'certbin_certs_app_env_status'
      index :common_name
      index :serial_number
      index :status
      index %i[expires_on status environment], name: 'certbin_certs_exp_on_status_env'

      index :first_certificate_id
      index :next_certificate_id
      index :last_certificate_id
    end
  end
end
