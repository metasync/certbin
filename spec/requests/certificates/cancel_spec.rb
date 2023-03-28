# frozen_string_literal: true

RSpec.describe "PUT /certificates/:id/cacnel", type: [:request, :database] do
  let(:request_headers) do
    {"HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json"}
  end

  context "given valid params" do
    it "cancels a certificate" do
      put "/certificates/#{@id}/cancel", {}.to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(@id)
      expect(certificate["status"]).to eq("cancelled")
      expect(certificate["cancelled_at"]).to be <= Time.now.to_s
    end

    it "cancels a certificate from a wrong status" do
      cert_repo.update(@id,
        status: "expired",
        expired_at: Time.now - 60 * 60,
      )

      put "/certificates/#{@id}/cancel", {}.to_json, request_headers

      certificate = JSON.parse(last_response.body)
      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result["status"].first).to eq("must be \"requested\"")
    end
  end

  context "given nonexistent certificate" do
    let(:nonexistent_id) { 10000 }

    it "returns error certificate not found" do
      put "/deployer/certificates/#{nonexistent_id}/retire", {}.to_json, request_headers

      expect(last_response).to be_not_found
    end
  end
end
