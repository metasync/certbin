# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :certificate_hosts do
      primary_key :id, type: :Bignum
      foreign_key :certificate_id, :certificates, type: :Bignum, on_delete: :cascade
      String :value, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index %i[value certificate_id], unique: true
    end
  end
end
