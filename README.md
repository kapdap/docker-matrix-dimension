# Dimension Docker

This repository contains a Docker image for Dimension.

## Overview

Dimension is "an open source integrations manager for matrix clients, like Riot".

Visit the [Dimension](https://dimension.t2bot.io/) website and [GitHub](https://github.com/turt2live/matrix-dimension) repo for more information.

## Quickstart

```sh
docker run -d -p 8184:8184 -e HOME_NAME=my.matrix.domain -e ADMIN_LIST=@me:my.matrix.domain kapdap/matrix-dimension
```

A `production.yaml` and admin token are generated on every run. Use a volume to persists these values.

```sh
docker run -d -p 8184:8184 -e HOME_NAME=my.matrix.domain -e ADMIN_LIST=@me:my.matrix.domain -v /path/to/config:/app/config kapdap/matrix-dimension
```

The admin token is printed to console log whenever a new one is generated. Set the environment variable `HOME_ACCESS_TOKEN=secret-token` or `HOME_ACCESS_TOKEN_FILE=/run/secrets/token` to use a fixed secret.

## Configuration

See [default.yaml](https://github.com/turt2live/matrix-dimension/blob/master/config/default.yaml) on the Dimension GitHub repo for a full explaination of the configuration values.

This image can be configured using environment variables or by providing a `production.yaml` file at `/app/config/production.yaml`.

Setting `GENERATE_CONFIG=true` will overwrite an existing `production.yaml`. This is useful if you want to provide a volume and keep `production.yaml` updated using env vars. `production.yaml` will always be generated if one cannot be found.

See `env.sample` for a full list of configurable environment variables.

Note: The `production.yaml` file name is set from the `NODE_ENV` environment variable.

### Admin Access Token

If `HOME_ACCESS_TOKEN_FILE` and `HOME_ACCESS_TOKEN` are unset a new token will be generated and saved to `/app/config/secret`. Tokens can be retreived from docker logs whenever a new one is generated.

```sh
docker logs -f <container-id>
Generating config /app/config/production.yaml
HOME_ACCESS_TOKEN_FILE and HOME_ACCESS_TOKEN are unset. A random access token will be generated and saved to /app/config/secret.
Provide a docker volume to persist this token across restarts. Tokens are printed to the console each time they are generated.

Z1BIYjR0WGQ3eWdNZDROYmFDZkJZQ3Bqbm01UmFndTk=
```

Tokens are used only when a new `production.yaml` is generated or `GENERATE_CONFIG=true`.

Finally, remember to set the `ADMIN_LIST` value to your Matrix Admin ID e.g. `@bob:my.matrix.domain,@jane:my.matrix.domain`.

## Building

Clone the repo:

```sh
git clone https://github.com/kapdap/docker-matrix-dimension.git && cd docker-matrix-dimension
```

Build the Docker image:

```sh
docker-compose build
docker-compose up
```

You can change the git branch and commit by setting the `GIT_BRANCH` and `GIT_COMMIT` build arguments.