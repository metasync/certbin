# Change log

## [0.3.1] - 2023-09-05

  * Changed error status to 500 (internal server errror) instead of 503 (service unavailable) for health check failure to be more semantically correct

## [0.3.0] - 2023-09-04

  * Revamped certificate renewal with linked certificate support
  * Supported audit log for certificate operations
  * Minor enhancements, bug fixes and code clean up

## [0.2.7] - 2023-07-31

  * Added Warden setting, #authorize_by_default, to control authorization enablement (Default: true)
  * Updated authorization header description in OpenAPI spec document
  * Added sample scripts to generate RSA key and RS256 auth token
  * Updated README
  * Minor typos fixes

## [0.2.6] - 2023-07-30

  * Refactored request authorization into Rack middleware

## [0.2.5] - 2023-07-28

  * Supported API authorization with RS256 JWT
  * Updated gem dependencies
  * Robocop fixes for Ruby Linter

## [0.2.4] - 2023-07-24

  * Added check for database liveness
  * Updated bundled gems

## [0.2.3] - 2023-07-22

  * Added namespace "tekton-ci" to image labels in Dockerfile
  * Used file volume instead of named volume to solve permission issue when mssql run as non-root user by default
  * Checked certificate request template for new certificate
  * Handled invalid cert request template when showing cert request

## [0.2.2] - 2023-06-02

  * Changed column #certificates.certificate_content to
    * use VARCHAR(MAX) for SQL Server
    * use TEXT for other databases
  * Fixed typo in docker compose config for mssql
  * Updated bundle config in Dockerfile instead of deprecated cli option "--without"

## [0.2.1] - 2023-06-02

  * Added test-runner stage in Dockerfile
  * Added amalgalite as sqlite driver for test-runner in image build
  * Upgraded base image to Ruby 3.2.2 on Alpine 3.18
  * Separated database user and password from database url to avoid messing up the database url with special characters
  * Added test spec runner script, run-spec, to facilitate test-runner stage in image build
  * Refactored docker-compose configuration
  
## [0.2.0] - 2023-06-01

  * Renamed certman to certbin
  * Refactored Dockerfile with image labels
  * Minor updates on docker-compose config

## [0.1.8] - 2023-05-09

  * Fixed issues on Dockerfile
  * Changed service port number from 2300 to 8080
  * Revised gitigonre and dockerigonre config

## [0.1.7] - 2023-04-24

  * Setup RuboCop of Ruby and RSpec
  * Fixed offenses and RuboCop of Ruby and RSpec
  * Created todoes for RuboCop of Ruby and RSpec
  * Revised test certbindb setup in docker compose

## [0.1.6] - 2023-04-23

  * Revised environment file for Hanami
  * Refactored docker compose files
  * Added dockerignore file
  * Supported PostgresSQL as database engine in addition to MSSQL
  * Fixed DateTime type for migration columns
  * Added Dockefiles to support local/remote image build

## [0.1.5] - 2023-04-21

  * Added support for API spec documentation generation
  * Updated README to reflect API spec document
  * Added API to retrieve certificate content
  * Revised cert content issue with pfx and crt support
  * Increased the text limit to 1MB for text column in SQL Server that is used to store certifcate content base64-encoded
  * Added sample certificates for test purpose
  * Minor code refactored and clean-up

## [0.1.0] - 2023-03-04

  * Initial release
  * Provided APIs for basic operations in certificate inventory management
