# frozen_string_literal: true

require "rack/test"

RSpec.shared_context "Hanami app" do
  let(:app) { Hanami.app }
end

RSpec.shared_context "sample certificate" do
  let(:cert_repo) { Inventory::Slice["repositories.certificates"] }

  let(:sample_date) { DateTime.parse("2023-03-26") }

  let(:sample_cert) do
    {
      status: "requested",
      organization_unit: "IT Dev",
      organization: "Example Company Limited",
      locality: "Macau",
      state_or_province: "Macau",
      country: "CN",
      owner: "App Support",
      email: "app_support@company.com",
      environment: "prd",
      application: "example",
      template: "webserver",
      key_size: 4096,
      common_name: "example.company.com",
      host: "prd-example-01",
      install_method: "OCP",
      reference_id: "1234567890",
      # serial_number: null,
      # issued_on: null,
      # expires_on: null,
      # certificate_content: null,
      requested_at: sample_date,
      # issued_at: null,
      # deployed_at: null,
      # renewed_at: null,
      # expired_at: null,
      # revoked_at: null,
      # withdrawn_at: null,
      # retired_at: null,
      # remarks: null,
      created_at: sample_date,
      updated_at: sample_date,
      dns_records: [
        {
          value: "example.company.com",
          created_at: sample_date,
          updated_at: sample_date
        },
        {
          value: "example",
          created_at: sample_date,
          updated_at: sample_date
        }
      ],
      ip_addresses: [
        {
          value: "233.233.233.233",
          created_at: sample_date,
          updated_at: sample_date
        }
      ]
    }
  end

  let(:nonexistent_id) { 10000000 }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
  config.include_context "Hanami app", type: :request
  config.include_context "sample certificate", type: :request
end
