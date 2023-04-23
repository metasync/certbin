ARG RUBY_IMAGE_TAG=3.2.1-alpine3.17
FROM docker.io/ruby:${RUBY_IMAGE_TAG} AS base

ENV APP_HOME=/home/app

RUN apk -U upgrade \
    && mkdir ${APP_HOME}

FROM base AS dependencies

RUN apk add --no-cache build-base curl git \
      freetds-dev mariadb-dev libpq-dev

WORKDIR ${APP_HOME}

COPY . .

RUN bundle config set without "development test" \
    && bundle install --jobs=3 --retry=3 \
    && rm -fr .git .bundle bundle document scripts

FROM base

ENV HISTFILE=${APP_HOME}/.bash_history

COPY --from=dependencies ${APP_HOME} ${APP_HOME}
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

RUN apk add --no-cache gcompat curl freetds-dev mariadb-dev libpq-dev \
    && chown -R 1001:0 ${APP_HOME} \
    && chmod -R g=u ${APP_HOME}

USER 1001

WORKDIR ${APP_HOME}

EXPOSE 2300
