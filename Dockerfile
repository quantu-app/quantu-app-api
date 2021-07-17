FROM elixir:1.12-alpine as builder

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

CMD ["sh", "-c", "mix ecto.setup ; mix phx.server"]

# RUN mix do compile, release

# FROM alpine:3.14

# RUN apk add --no-cache openssl ncurses-libs libstdc++ libgcc

# WORKDIR /app
# ENV HOME=/app

# ARG MIX_ENV prod
# ENV MIX_ENV=$MIX_ENV

# RUN chown -R nobody:nobody /app

# COPY --from=builder --chown=nobody:nobody /app/_build/$MIX_ENV/rel/quantu_app ./

# CMD ["sh", "-c", "bin/quantu_app eval \"Quantu.App.Release.setup\" ; bin/quantu_app start"]