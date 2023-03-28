# frozen_string_literal: true

RSpec.describe "PUT /issuer/certificates", type: [:request, :database] do
  let(:request_headers) do
    {"HTTP_ACCEPT" => "application/json", "CONTENT_TYPE" => "application/json"}
  end

  context "given valid params" do
    let(:params) do
      {
        certificate: {
          certificate_content: %{-----BEGIN CERTIFICATE-----
MIIFTjCCBDagAwIBAgIQBHr3lUfAfQ/vgKWyH1HjYzANBgkqhkiG9w0BAQsFADCB
kDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxNjA0BgNV
BAMTLUNPTU9ETyBSU0EgRG9tYWluIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBD
QTAeFw0xODAzMTIwMDAwMDBaFw0yMDAzMTEyMzU5NTlaMFIxITAfBgNVBAsTGERv
bWFpbiBDb250cm9sIFZhbGlkYXRlZDEUMBIGA1UECxMLUG9zaXRpdmVTU0wxFzAV
BgNVBAMTDmFjcy5xYWNhZmUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA6/61GhYNST8VGJlE62Pv5H7e95EqLzydQ1diUpIXpkgL3oZDa3dcd50F
bGTrlvqXyPmTPnI8xITz4phgnBeSvwESoyBpGRY5HEgL4NvivNBIV02mDRqhOlEl
tdkcYbo0t3ZWFXJ+aesHDyA++UFWixtR61XNnGGhyKFCH26HXqEbaBHlTmY2fEos
I+SYcTH3DCjuHWWZHR9AHtq1pN5bbY3DNTsGtF2CpmEnKSWrcRJxnAz2aMFUWDod
oc7qEKYt4Er19EW0LSU39Q6ywwMfNXNZRjZqc6IsP3DI5CZJoyCPOHxV0C71iiQA
e842jWBae8VLZs1J0OZRbbWeqGgGeQIDAQABo4IB3zCCAdswHwYDVR0jBBgwFoAU
kK9qOpRaC9iQ6hJWc99DtDoo2ucwHQYDVR0OBBYEFMwxDzaFkpGoDWFGnpz+niNC
udaSMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsG
AQUFBwMBBggrBgEFBQcDAjBPBgNVHSAESDBGMDoGCysGAQQBsjEBAgIHMCswKQYI
KwYBBQUHAgEWHWh0dHBzOi8vc2VjdXJlLmNvbW9kby5jb20vQ1BTMAgGBmeBDAEC
ATBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01P
RE9SU0FEb21haW5WYWxpZGF0aW9uU2VjdXJlU2VydmVyQ0EuY3JsMIGFBggrBgEF
BQcBAQR5MHcwTwYIKwYBBQUHMAKGQ2h0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NP
TU9ET1JTQURvbWFpblZhbGlkYXRpb25TZWN1cmVTZXJ2ZXJDQS5jcnQwJAYIKwYB
BQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAtBgNVHREEJjAkgg5hY3Mu
cWFjYWZlLmNvbYISd3d3LmFjcy5xYWNhZmUuY29tMA0GCSqGSIb3DQEBCwUAA4IB
AQBE/SmWs8rJthBedEAUaqDEQSFbFgviE+uKJRlfMHMPK55oe2c7cdujcpFS2wKM
E7P9cS5KTNECbn4fDgrPuylxkUKK6GiPorTWUuT0k98TmKRY5nfkeIaurXO3bUMl
3R+SwDaXBCqHQIcWFsN5ExCiLqDLJw/uxloaW1Vbt50gEnyLDSAyPozBWlYxJw77
TNd6rcUiWK2Xx711FLvnWPXI9kn4Q2gTLtQ6ZwIT6DVQBd/ZMpDhxruwqlL7Tx+S
3dNVeihnkb7AXLd7dDcO2Gk29XS5o2F8KTE+i1Gi3/z03EiTRsmyNTBsSGYqbvVv
F9crB7TEuWdlZxrYdoCP//3v
-----END CERTIFICATE-----
          }
        }
      }
    end

    it "issues a requested certificate" do
      params[:certificate][:id] = @id
      put "/issuer/certificates/issue", params.merge().to_json, request_headers

      expect(last_response).to be_ok

      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(params[:certificate][:id])
      expect(certificate["certificate_content"]).to eq(params[:certificate][:certificate_content])
      expect(certificate["status"]).to eq("issued")
      expect(certificate["issued_at"]).to be <= Time.now.to_s
    end

    it "issues a renewing certificate" do
      params[:certificate][:id] = @id
      cert_repo.update(@id, status: "renewing")
      put "/issuer/certificates/issue", params.merge().to_json, request_headers
  
      expect(last_response).to be_ok
  
      certificate = JSON.parse(last_response.body)
      expect(certificate["id"]).to eq(params[:certificate][:id])
      expect(certificate["certificate_content"]).to eq(params[:certificate][:certificate_content])
      expect(certificate["status"]).to eq("issued")
      expect(certificate["renewed_at"]).to be <= Time.now.to_s
    end

    it "issues an nonexistent certificate" do
      params[:certificate][:id] = nonexistent_id
      put "/issuer/certificates/issue", params.merge().to_json, request_headers
  
      expect(last_response).to be_not_found
    end
  end

  context "given missing certificate content" do
    let(:invalid_params) do
      {certificate: {id: 1}}
    end

    it "returns 422 unprocessable" do
      put "/issuer/certificates/issue", invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
    end
  end

  context "given invalid certificate content" do
    let(:invalid_params) do
      {certificate: {id: 1000, certificate_content: "abc"}}
    end

    it "returns 422 unprocessable" do
      put "/issuer/certificates/issue", invalid_params.to_json, request_headers

      expect(last_response).to be_unprocessable
      result = JSON.parse(last_response.body)
      expect(result["error"]).not_to be(nil)
    end
  end
end
