FROM hexpm/elixir:1.14.0-erlang-25.1-alpine-3.15.6 AS base

WORKDIR /rustler_benchmark

RUN mix do local.hex --force, local.rebar --force

RUN apk add npm inotify-tools curl bash rustup build-base

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV RUSTFLAGS="-C target-feature=-crt-static"
ENV PATH="/root/.cargo/bin:${PATH}"

# -----------------
# BUILD
# -----------------
FROM base AS build

RUN apk add curl bash git

ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
COPY . ./

# install application
RUN mix do deps.get, compile

# -----------------
# RELEASE
# -----------------
FROM build AS release

# digests and compresses static files
RUN mix assets.deploy

# generate release executable
RUN mix release

# -----------------
# PRODUCTION
# -----------------
FROM alpine:3.15.6

WORKDIR /rustler_benchmark

ARG MIX_ENV=prod

# install dependencies
RUN apk add ncurses-libs curl libgcc libstdc++

COPY --from=release /rustler_benchmark/_build/$MIX_ENV/rel/rustler_benchmark ./

# start application
CMD ["bin/rustler_benchmark", "start"]