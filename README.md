# Certbin

Certbin is a JSON API service to manage SSL certificate inventory.

There are three major categories of APIs:

  * Requester APIs
    * Request new certificate
    * Cancel new certificate request
    * Retrieve certificates with different filters

  * Issuer APIs
    * Manage certificate lifecycle
    * Integration is required for actual certificate creation

  * Deployer APIs
    * Manage certificate deployment
    * Integration is required for actual certiifcate deployment


ATTN: all APIs are in JSON format so please ensure the content type in HTTP header is properly configured. The response is also in JSON format. You can use "jq" to parse the response directly for convenience if needed.

# JSON API Specifications

## API Authorization

Bearer authentication is used for API authorization in Certbin. Certbin client must send its bearer token in the Authorization header when making requests to Certbin APIs.

```
Authorization: Bearer <auth_token>
```

Bearer token is a JWT signed with algorithm RS256 (RSA using SHA-256 hash algorithm).

```
require 'jwt'
require 'openssl'

payload = {
  iss: 'issuer',
  iat: Time.now.to_i,
  exp: Time.now.to_i + (expires_in * 60),
  data: {
    user: 'user.name'
  }
}
private_key = OpenSSL::PKey::RSA.generate 4096
auth_token = JWT.encode(payload, private_key, 'RS256')
```

The following JWT claims are required for any payload:

  * 'iss' (Issuer) Claim
  * 'iat' (Issued At) Claim
  * 'exp' (Expiration Time) Claim

Also, public key needs to be provided. the public key file should be named as the same as that for the issuer. For example, if the issuer is "devops", the public key file should be named as "devops.pub" and saved in the "authorized_keys" folder under the application service root. The private key file should be managed ONLY by the issuer.

## View API specifications online (recommended)

You can view API spec online by uploading [certbin_spc.yml](/document/openapi_spec/certbin_openapi.yaml) to online Swagger Editor:

https://editor.swagger.io

This is the simplest and recommended way.

## Run API specification web server (Swagger UI)

You can run Swaggger UI web server locally:

```
make run.api.doc

(Press Ctrl+C to quit.)
```

Now open your browser to view the API spec:

```
http://localhost:8080
```

## Build API specification as HTML

You can also build API specification as a single HTML file:

```
make build.api.html2
```

The html file is saved under /document/openapi_spec/out

## Configuration

The following are the environment variables to be configured in the runtime environment.

  * General
    * ENVIRONMENTS
      List of valid environments (comma separated)
      e.g., ENVIRONMENTS=dev,qa,prd

  * Database
    * DB_ADAPTER
    * DB_HOST
    * DB_NAME
    * DB_USER
    * DB_PASSWORD
    * DATABASE_URL
      It is recommended not to include DB_USER and DB_PASSWORD into DATABASE_URL
    
  * Certificate Generation
    * CERT_TEMPLATES
      List of valid certificate templates (comma separated)
      e.g., CERT_TEMPLATES=webserver,appserver
    * Default metadata for each certificate:
      * ORGANIZATION
      * LOCALITY
      * STATE_OR_PROVINCE
      * COUNTRY
  
  * Certificate Operations 
    * DAYS_BEFORE_RENEWAL
      Number of days before renewal is allowed
    * DAYS_BEFORE_RETIREMENT
      Number of days before retirement is allowed

  * Authorization
    * AUTH_TOKEN_ISSUERS
      List of valid issuers (comma separated)
      e.g., AUTH_TOKEN_ISSUERS=devops,syseng
    * AUTHORIZE_BY_DEFAULT
      Turned on/off authorization (true/false)
      Default is true

# Todos

  * Support token-based authentication (done)
  * Support database credential encryption
  * Support certificate history (done)
