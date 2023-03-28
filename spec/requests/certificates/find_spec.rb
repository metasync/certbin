# frozen_string_literal: true

RSpec.describe "GET /certificates", type: :request do
  let(:common_name) { "example.company.com" }
  context "finds certificates by common name" do
    it "returns certificates with the given common name" do
      get "/certificates/common_name/#{common_name}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["common_name"]).to eq(common_name)
      end
    end
  end

  let(:ip_address) { "233.233.233.233" }

  context "finds certificates by ip address" do
    it "returns certificates with the given ip address" do
      get "/certificates/ip_address/#{ip_address}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["ip_addresses"].map do |ip_address|
          ip_address["value"]
        end).to include(ip_address)
      end
    end
  end

  let(:dns_record) { "example.company.com" }

  context "finds certificates by dns record" do
    it "returns certificates with the given dns record" do
      get "/certificates/dns_record/#{dns_record}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["dns_records"].map do |dns_record|
          dns_record["value"]
        end).to include(dns_record)
      end
    end
  end

  let(:status) { "requested" }

  context "finds certificates by status" do
    it "returns certificates with the given status" do
      get "/certificates/status/#{status}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq(status)
      end
    end
  end

  let(:host) { "prd-example-01" }

  context "finds certificates by host" do
    it "returns certificates with the given host" do
      get "/certificates/host/#{host}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["host"]).to eq(host)
      end
    end
  end

  context "finds certificates by id" do
    it "returns certificates with the given id" do
      get "/certificates/id/#{@id}"

      expect(last_response).to be_successful

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
    end

    it "returns 422 unprocessable" do
      get "/certificates/id/abc"

      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result["id"].first).to eq("must be an integer")
    end
  end

  context "finds certificates with non-existent id" do
    it "returns 404 not found" do
      get "/certificates/id/#{nonexistent_id}"

      expect(last_response).to be_not_found

      result = JSON.parse(last_response.body)
      expect(result["error"]).to eq("Certificate is NOT found.")
    end

    it "returns 422 unprocessable" do
      get "/certificates/id/abc"

      expect(last_response).to be_unprocessable
    end
  end

  context "finds retirable certificates" do
    it "returns retirable certificates" do
      cert_repo.update(@id, 
        status: "expired",
        expired_at: Time.now - (app.settings.days_before_retirement + 1) * 24 * 60 * 60
      )

      get "/certificates/retirable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("expired")
        expect(certificate["expired_at"]).to be <= (Time.now - Hanami.app["settings"].days_before_retirement * 24 * 60 * 60).to_s
      end
    end
  end

  context "finds withdrawable certificates" do
    it "returns withdrawable certificates" do
      cert_repo.update(@id, 
        status: "revoked",
        revoked_at: Time.now
      )

      get "/certificates/withdrawable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("revoked")
      end
    end
  end

  context "finds expirable certificates" do
    it "returns expirable deployed certificates" do
      cert_repo.update(@id, 
        status: "deployed",
        expires_on: Time.now - 60 * 60
      )

      get "/certificates/expirable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("deployed")
        expect(certificate["expires_on"]).to be <= Time.now.to_s
      end
    end

    it "returns expirable issued certificates" do
      cert_repo.update(@id, 
        status: "issued",
        expires_on: Time.now - 60 * 60
      )

      get "/certificates/expirable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("issued")
        expect(certificate["expires_on"]).to be <= Time.now.to_s
      end
    end
  end

  let(:days) { 1 }

  context "finds certificates that expire in given days" do
    it "returns expirable certificates that expire in given days" do
      cert_repo.update(@id, 
        status: "deployed",
        expires_on: Time.now + 12 * 60 * 60
      )

      get "/certificates/expires_in/#{days}"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("issued").or eq("deployed")
        expect(certificate["expires_on"]).to be <= (Time.now + days * 24 * 60 * 60).to_s
        expect(certificate["expires_on"]).to be > Time.now.to_s
      end
    end
  end

  context "finds requested certificates" do
    it "returns requested certificates" do
      get "/certificates/requested"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("requested")
      end
    end
  end

  context "finds issued certificates" do
    it "returns issued certificates" do
      cert_repo.update(@id, 
        status: "issued",
        issued_at: Time.now
      )

      get "/certificates/issued"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("issued")
      end
    end
  end

  context "finds deployed certificates" do
    it "returns deployed certificates" do
      cert_repo.update(@id, 
        status: "deployed",
        deployed_at: Time.now
      )

      get "/certificates/deployed"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("deployed")
      end
    end
  end

  context "finds renewing certificates" do
    it "returns renewing certificates" do
      cert_repo.update(@id, 
        status: "renewing"
      )

      get "/certificates/renewing"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("renewing")
      end
    end
  end

  context "finds revoking certificates" do
    it "returns revoking certificates" do
      cert_repo.update(@id, 
        status: "revoking"
      )

      get "/certificates/revoking"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("revoking")
      end
    end
  end

  context "finds revoked certificates" do
    it "returns revoked certificates" do
      cert_repo.update(@id, 
        status: "revoked",
        revoked_at: Time.now
      )

      get "/certificates/revoked"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("revoked")
      end
    end
  end

  context "finds renewable certificates" do
    it "returns renewable deployed certificates" do
      cert_repo.update(@id, 
        status: "deployed",
        expired_at: nil,
        expires_on: Time.now + 24 * 60 * 60
      )

      get "/certificates/renewable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("deployed")
        expect(certificate["expires_on"]).to be <= (Time.now + days * 24 * 60 * 60).to_s
        expect(certificate["expires_on"]).to be > Time.now.to_s
      end
    end

    it "returns renewable expired certificates" do
      cert_repo.update(@id, 
        status: "expired",
        expired_at: Time.now - 24 * 60 * 60
      )

      get "/certificates/renewable"

      expect(last_response).to be_successful

      certificates = JSON.parse(last_response.body)
      expect(certificates.size).to be >= 1
      certificates.each do |certificate|
        expect(certificate["status"]).to eq("expired")
        expect(certificate["expired_at"]).to be <= Time.now.to_s
      end
    end
  end
end
