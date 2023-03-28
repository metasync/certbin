# frozen_string_literal: true

RSpec.describe "PUT /issuer/certificates/:id/expire", type: [:request, :database] do
  let(:request_headers) do
    {"HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json"}
  end

  context "given valid params" do
    it "expires an issued certificate" do
      cert_repo.update(@id,
        status: "issued",
        issued_at: Time.now - 24 * 60 * 60,
        expires_on: Time.now - 60 * 60
      )

      put "/issuer/certificates/#{@id}/expire", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
      expect(certificate["status"]).to eq("expired")
    end

    it "expires a deployed certificate" do
      cert_repo.update(@id,
        status: "deployed",
        deployed_at: Time.now - 24 * 60 * 60,
        expires_on: Time.now - 60 * 60
      )

      put "/issuer/certificates/#{@id}/expire", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
      expect(certificate["status"]).to eq("expired")
    end

    it "expires a non-expiring certificate" do
      cert_repo.update(@id,
        status: "deployed",
        deployed_at: Time.now,
        expires_on: Time.now + 24 * 60 * 60
      )

      put "/issuer/certificates/#{@id}/expire", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result["expires_on"].first).to eq("is NOT yet reached")
    end

    it "expires a certificate from wrong status" do
      put "/issuer/certificates/#{@id}/expire", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      result = JSON.parse(last_response.body)
      expect(result["status"].first).to eq('must be "deployed" or "issued"')
    end
  end

  context "given nonexistent certificate" do
    let(:nonexistent_id) { 10000 }

    it "returns error certificate not found" do
      put "/issuer/certificates/#{nonexistent_id}/expire", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
