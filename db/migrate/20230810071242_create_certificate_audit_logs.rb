# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :certificate_audit_logs do
      primary_key :id, type: :Bignum

      Bignum :certificate_id, null: false
      Bignum :first_certificate_id, null: false

      if ENV['DB_ADAPTER'] == 'tinytds'
        #   # Use VARCHAR(MAX) for SQL Server
        #   String :before, size: :max, null: false
        #   String :after, size: :max, null: false
        String :changes, size: :max, null: false
      else
        #   # Use TEXT for other databases
        #   String :before, text: true, null: false
        #   String :after, text: true, null: false
        String :changes, text: true, null: false
      end

      # Actions:
      # request, cancel, issue, deploy,
      # renew, renew_complete, expire, retire
      # revoke, revoke_complete, withdraw
      String :action, null: false
      String :actioned_by, null: false
      String :action_group, null: false
      DateTime :actioned_at, null: false
      DateTime :created_at, null: false

      index :certificate_id
      index :first_certificate_id
      index %i[actioned_at action]
      index %i[actioned_at actioned_by]
      index %i[actioned_at action_group]
    end
  end
end
