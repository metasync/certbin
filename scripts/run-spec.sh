#!/bin/sh

set -a
source ${APP_HOME}/docker/common.env
source ${APP_HOME}/docker/sqlite/database.env
HANAMI_ENV=test bundle exec rake db:migrate
HANAMI_ENV=test bundle exec rspec spec/requests
