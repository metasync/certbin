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


# Todos

  * Support token-based authentication
  * Support database credential encryption
  * Support certificate history
