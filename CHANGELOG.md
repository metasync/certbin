# Change log

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
