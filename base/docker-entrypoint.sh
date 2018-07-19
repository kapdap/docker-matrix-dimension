#!/bin/sh

U_ID=${U_ID:-1000}
G_ID=${G_ID:-${U_ID}}

# Flexible docker entrypoint scripts adapted from
# https://www.camptocamp.com/en/actualite/flexible-docker-entrypoints-scripts/

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
  /bin/run-parts "$DIR"
fi

exec gosu ${U_ID}:${G_ID} "$@"