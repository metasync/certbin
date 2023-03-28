# frozen_string_literal: true

RSpec.describe "PUT /deployer/certificates/:id/withdraw", type: [:request, :database] do
  let(:request_headers) do
    {"HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json"}
  end

  context "given valid params" do
    it "revokes a certificate" do
      cert_repo.update(@id,
        status: "revoked",
        revoked_at: Time.now
      )

      put "/deployer/certificates/#{@id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
      expect(certificate["status"]).to eq("withdrawn")
      expect(certificate["withdrawn_at"]).to be <= Time.now.to_s
    end

    it "revokes a certificate from a wrong status" do
      put "/deployer/certificates/#{@id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_unprocessable

      certificate = JSON.parse(last_response.body)
      expect(certificate["status"].first).to eq('must be "revoked"')
    end
  end

  context "given nonexistent certificate" do
    let(:nonexistent_id) { 10000 }

    it "returns error certificate not found" do
      put "/deployer/certificates/#{nonexistent_id}/withdraw", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
