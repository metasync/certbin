include Makefile.env

# build.certman:
# 	@${CONTAINER_CLI} build . \
# 		-t ${CERTMAN_IMAGE} \
# 		--build-arg CHRONOS_IMAGE_TAG=${CHRONOS_IMAGE_TAG} \
# 		--build-arg PROJECT=$(project)

# run.simulator:
# 	@${CONTAINER_CLI} run --rm -it \
# 		${SIMULATOR_IMAGE} /bin/sh

up:
	@${CONTAINER_CLI} compose up -d
up.dev:
	@${CONTAINER_CLI} compose -f docker-compose.yml -f docker-compose.dev.yml up -d
down:
	@${CONTAINER_CLI} compose down
ps:
	@${CONTAINER_CLI} ps -a
logs:
	@${CONTAINER_CLI} compose logs -f

up.certman:
	@${CONTAINER_CLI} compose up certman -d
shell.certman:
	@${CONTAINER_CLI} compose exec certman /bin/sh
restart.certman:
	@${CONTAINER_CLI} compose restart certman
logs.certman:
	@${CONTAINER_CLI} compose logs certman -f

shell.certmandb:
	@${CONTAINER_CLI} compose exec certmandb /bin/bash
logs.certmandb:
	@${CONTAINER_CLI} compose logs certmandb -f

shell.certmandb.test:
	@${CONTAINER_CLI} compose exec certmandb.test /bin/bash
logs.certmandb.test:
	@${CONTAINER_CLI} compose logs certmandb.test -f

reset:
	@${CONTAINER_CLI} volume rm certman_dev_certmandb certman_test_certmandb

.PHONY: up up.dev down ps logs \
		up.certman shell.certman restart.certman logs.certman \
		shell.certmandb logs.certmandb \
		shell.certmandb.test logs.certmandb.test \
		reset
