
ARG base_image_repo=ruby
ARG base_image_tag
ARG base_image_digest
FROM ${base_image_repo}:${base_image_tag}@${base_image_digest} AS base

ENV APP_HOME=/home/app

RUN apk -U upgrade \
    && mkdir ${APP_HOME}

FROM base AS dependencies

RUN apk add --no-cache build-base curl \
      freetds-dev mariadb-dev libpq-dev

WORKDIR ${APP_HOME}

COPY . .

RUN bundle config set without "development test" \
    && bundle install --jobs=3 --retry=3

FROM dependencies AS test-runner

RUN bundle config set without "" \
    && bundle install --jobs=3 --retry=3 \
    && ${APP_HOME}/scripts/run-spec.sh  | tee ${APP_HOME}/scripts/run-spec.result

FROM base

ARG project
ARG app
ARG version
ARG revision
ARG release_tag=rel
ARG build_number=0
ARG source
ARG build_context
ARG dockerfile
ARG image_repo
ARG image_tag
ARG base_image_repo
ARG base_image_tag
ARG base_image_digest

ARG ruby_version
ARG alpine_version

LABEL project=${project} \
    app=${app} \
    version=${version} \
    revision=${revision} \
    release_tag=${release_tag} \
    build_number=${build_number} \
    source=${source} \
    build_context=${build_context} \
    dockerfile=${dockerfile} \
    vendor="Metasync" \
    \
    image_repo=${image_repo} \
    image_tag=${image_tag} \
    image_name=${image_repo}:${image_tag} \
    \
    base_image_repo=${base_image_repo} \
    base_image_tag=${base_image_tag} \
    base_image_name=${base_image_repo}:${base_image_tag} \
    base_image_digest=${base_image_digest} \
    \
    ruby_version=${ruby_version} \
    alpine_version=${alpine_version}

ENV HISTFILE=${APP_HOME}/.bash_history

COPY --from=dependencies ${APP_HOME} ${APP_HOME}
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=test-runner ${APP_HOME}/scripts/run-spec.result ${APP_HOME}/scripts/run-spec.result

RUN apk add --no-cache gcompat curl \
        freetds-dev mariadb-dev libpq-dev \
    && chown -R 1001:0 ${APP_HOME} \
    && chmod -R g=u ${APP_HOME}

USER 1001

WORKDIR ${APP_HOME}

EXPOSE 8080

