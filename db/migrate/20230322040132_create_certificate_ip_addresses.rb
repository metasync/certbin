# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :certificate_ip_addresses do
      primary_key :id, type: :Bignum
      foreign_key :certificate_id, :certificates, type: :Bignum, on_delete: :cascade
      String :value, null: false
      Datetime :created_at, null: false
      Datetime :updated_at, null: false

      index [:value, :certificate_id], unique: true
    end
  end
end
