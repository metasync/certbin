include Makefile.env

build.certbin:
	@${CONTAINER_CLI} build . \
		-t ${CERTBIN_IMAGE} \
		--build-arg RUBY_IMAGE_TAG=${RUBY_IMAGE_TAG}

up:
	@cd docker && ${CONTAINER_CLI} compose up -d
down:
	@cd docker && ${CONTAINER_CLI} compose down
ps:
	@cd docker && ${CONTAINER_CLI} compose ps -a
logs:
	@cd docker && ${CONTAINER_CLI} compose logs -f

up.certbin:
	@cd docker && ${CONTAINER_CLI} compose up certbin -d
shell.certbin:
	@cd docker && ${CONTAINER_CLI} compose exec certbin /bin/sh
restart.certbin:
	@cd docker && ${CONTAINER_CLI} compose restart certbin
logs.certbin:
	@cd docker && ${CONTAINER_CLI} compose logs certbin -f

shell.certbindb:
	@cd docker && ${CONTAINER_CLI} compose exec certbindb /bin/bash
logs.certbindb:
	@cd docker && ${CONTAINER_CLI} compose logs certbindb -f

shell.certbindb.test:
	@cd docker && ${CONTAINER_CLI} compose exec certbindb.test /bin/bash
logs.certbindb.test:
	@cd docker && ${CONTAINER_CLI} compose logs certbindb.test -f

reset:
	@${CONTAINER_CLI} volume rm certbin_dev_certbindb_$(adapter) certbin_test_certbindb_$(adapter)

build.api.html2:
	@${CONTAINER_CLI} run --rm \
		-v ${OPENAPI_SPEC_PATH}:/local openapitools/openapi-generator-cli:v6.5.0 generate \
		-i /local/certbin_spec.yml \
		-g html2 \
		-o /local/out/html2

build.api.powershell:
	@${CONTAINER_CLI} run --rm \
		-v ${OPENAPI_SPEC_PATH}:/local openapitools/openapi-generator-cli:v6.5.0 generate \
		-i /local/certbin_spec.yml \
		-g powershell  \
		-o /local/out/powershell 

validate.api.spec:
	@${CONTAINER_CLI} run --rm \
		-v ${OPENAPI_SPEC_PATH}:/local openapitools/openapi-generator-cli:v6.5.0 validate \
		-i /local/certbin_spec.yml --recommend

run.api.doc:
	@${CONTAINER_CLI} run --rm \
		-p 8080:8080 \
		--name certbin-openapi \
		-e SWAGGER_JSON=/api_spec/certbin_spec.yml \
		-e DEFAULT_MODELS_EXPAND_DEPTH=10 \
		-v ${OPENAPI_SPEC_PATH}:/api_spec/ swaggerapi/swagger-ui:v5.0.0-alpha.6

prune:
	@${CONTAINER_CLI} image prune -f
clean: prune

.PHONY: up down ps logs \
		up.certbin shell.certbin restart.certbin logs.certbin \
		shell.certbindb logs.certbindb \
		shell.certbindb.test logs.certbindb.test \
		reset \
		build.certbin \
		build.api.html2 build.api.powershell validate.api.spec run.api.doc \
		prune clean
