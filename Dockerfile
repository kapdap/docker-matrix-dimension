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
    G_ID=1000 \
    HOST_PORT=8184

WORKDIR /app

RUN apk --no-cache add --upgrade -t build-deps git \
 && apk --no-cache add --upgrade ca-certificates \
 && chown ${U_ID}:${G_ID} /app

# Temporarly change to user account
USER ${U_ID}:${G_ID}

ARG APP_URL=https://github.com/turt2live/matrix-dimension.git
ARG GIT_BRANCH=master
ARG GIT_COMMIT

RUN git clone ${APP_URL} . \
 && git checkout ${GIT_BRANCH} \
 && git reset --hard ${GIT_COMMIT} \
 && npm install \
 && NODE_ENV=production npm run-script build:web \
 && NODE_ENV=production npm run-script build:app \

USER 0

RUN apk --purge del build-deps git \
 && rm -rf /var/cache/apk/*

# Copy image base files to /
COPY base/ /

# Ensure entrypoint executable bits are set
RUN chmod +x /docker-entrypoint.sh \
 && chmod +x /docker-entrypoint.d/*

# Add additional entrypoint scripts in downstream builds
ONBUILD COPY docker-entrypoint.d/ /docker-entrypoint.d/
ONBUILD RUN  chmod +x /docker-entrypoint.d/*

ENV NODE_ENV=production

VOLUME [ "/app/config/" ]

EXPOSE $HOST_PORT

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "npm", "run", "start:app" ]