FROM kapdap/alpine-gosu AS gosu
LABEL maintainer "kapdap.nz@gmail.com"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF=${BUILD_VERSION}

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="kapdap/matrix-dimension" \
      org.label-schema.description="An open source integrations manager for matrix clients, like Riot." \
      org.label-schema.url="https://dimension.t2bot.io/" \
      org.label-schema.vcs-url="https://github.com/kapdap/docker-matrix-dimension" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="kapdap" \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.docker.cmd="docker run -d kapdap/matrix-dimension"

# Download application and supporting packages
#    https://github.com/turt2live/matrix-dimension
FROM node:8-alpine

COPY --from=gosu /usr/bin/gosu /usr/bin/gosu

RUN apk --no-cache add -t build-deps git \
 && apk --no-cache add ca-certificates

ENV U_ID=1000 \
    G_ID=1000

WORKDIR /app

RUN chown ${U_ID}:${G_ID} /app

USER ${U_ID}:${G_ID}

ARG APP_URL=https://github.com/turt2live/matrix-dimension.git
ARG GIT_BRANCH=master
ARG GIT_COMMIT

RUN git clone ${APP_URL} . \
 && git checkout ${GIT_BRANCH} \
 && git reset --hard ${GIT_COMMIT} \
 && NODE_ENV=development npm install \
 && npm run-script build:web \
 && npm run-script build:app

USER 0

RUN apk --purge del build-deps \
 && rm -rf /var/cache/apk/*

COPY base/ /

RUN chmod +x /docker-entrypoint.sh \
 && chmod +x /docker-entrypoint.d/*

# Add additional entrypoint scripts in downstream builds
ONBUILD COPY docker-entrypoint.d/ /docker-entrypoint.d/
ONBUILD RUN  chmod +x /docker-entrypoint.d/*

ENV HOST_PORT=8184 \
    NODE_ENV=production

EXPOSE $HOST_PORT

VOLUME [ "/app/config/" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "npm", "run", "start:app" ]