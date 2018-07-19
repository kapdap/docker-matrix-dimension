FROM node:8-alpine
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

# Install gosu (ToDo: Move to seperate image)
#   https://github.com/mendsley/docker-alpine-gosu

# 036A9C25BF357DD4 - Tianon Gravi <tianon@tianon.xyz>
#   http://pgp.mit.edu/pks/lookup?op=vindex&search=0x036A9C25BF357DD4
ARG GOSU_VERSION="1.10"
ARG GOSU_ARCHITECTURE="amd64"
ARG GOSU_DOWNLOAD_URL="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$GOSU_ARCHITECTURE"
ARG GOSU_DOWNLOAD_SIG="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$GOSU_ARCHITECTURE.asc"
ARG GOSU_DOWNLOAD_KEY="0x036A9C25BF357DD4"

# Download and install gosu
#   https://github.com/tianon/gosu/releases
RUN buildDeps='curl gnupg' HOME='/root' \
	&& apk --no-cache add --upgrade $buildDeps \
	&& gpg-agent --daemon \
	&& gpg --keyserver pool.sks-keyservers.net --recv-keys $GOSU_DOWNLOAD_KEY \
	&& echo "trusted-key $GOSU_DOWNLOAD_KEY" >> /root/.gnupg/gpg.conf \
	&& curl -sSL "$GOSU_DOWNLOAD_URL" > gosu-$GOSU_ARCHITECTURE \
	&& curl -sSL "$GOSU_DOWNLOAD_SIG" > gosu-$GOSU_ARCHITECTURE.asc \
	&& gpg --verify gosu-$GOSU_ARCHITECTURE.asc \
	&& rm -f gosu-$GOSU_ARCHITECTURE.asc \
	&& mv gosu-$GOSU_ARCHITECTURE /usr/bin/gosu \
	&& chmod +x /usr/bin/gosu \
    && apk del --purge $buildDeps \
	&& rm -rf /root/.gnupg

# Download application and supporting packages
#    https://github.com/turt2live/matrix-dimension
ARG APP_URL=https://github.com/turt2live/matrix-dimension.git
ARG GIT_BRANCH=master
ARG GIT_COMMIT

ENV U_ID=1000 \
    G_ID=1000 \
    HOST_PORT=8184

WORKDIR /app

RUN apk --no-cache add --upgrade -t build-deps git \
 && apk --no-cache add --upgrade ca-certificates

RUN git clone ${APP_URL} . \
 && git checkout ${GIT_BRANCH} \
 && git reset --hard ${GIT_COMMIT} \
 && npm install \
 && apk --purge del build-deps \
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