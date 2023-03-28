# frozen_string_literal: true

RSpec.describe "GET /issuer/certificates/:id/cert_request", type: :request do
  context "show certificate request for a given certificate" do
    # let(:id) { cert_repo.create(sample_cert).id }

    it "return certificate request" do
      get "/issuer/certificates/#{@id}/cert_request"
  
      expect(last_response).to be_successful
  
      cert_request = JSON.parse(last_response.body)

      expect(cert_request["id"]).to eq(@id)
      expect(cert_request["cert_request"]).not_to be(nil)
    end
  end

  context "show certificate request with a non-existent id" do
    it "return error certificate not found" do
      get "/issuer/certificates/#{nonexistent_id}/cert_request"
  
      expect(last_response).to be_not_found

      result = JSON.parse(last_response.body)
      expect(result["error"]).to eq("Certificate is NOT found.")
    end
  end
end
