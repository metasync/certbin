# frozen_string_literal: true

RSpec.describe "PUT /issuer/certificates/:id/revoke_complete", type: [:request, :database] do
  let(:request_headers) do
    {"HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json"}
  end

  context "given valid params" do
    it "revokes a certificate complete" do
      cert_repo.update(@id,
        status: "revoking"
      )

      put "/issuer/certificates/#{@id}/revoke_complete", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
      expect(certificate["status"]).to eq("revoked")
      expect(certificate["revoked_at"]).to be <= Time.now.to_s
    end
  end

  context "given nonexistent certificate" do
    let(:nonexistent_id) { 10000 }

    it "returns error certificate not found" do
      put "/issuer/certificates/#{nonexistent_id}/revoke_complete", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
