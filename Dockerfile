FROM elixir:1.11-alpine as builder

RUN apk add --no-cache build-base

WORKDIR /app

ARG MIX_ENV prod
ENV MIX_ENV=$MIX_ENV

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY priv priv
COPY lib lib

RUN mix do compile, release

FROM alpine:3.14

RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app
ENV HOME=/app

ARG MIX_ENV prod
ENV MIX_ENV=$MIX_ENV

COPY --from=builder /app/_build/$MIX_ENV/rel/quantu_app ./

CMD bin/quantu_app eval "Quantu.App.Release.setup" && bin/quantu_app start