FROM elixir:1.11

RUN apt update
RUN apt install postgresql-client -y
RUN apt autoclean -y

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock

RUN mix deps.get && mix deps.compile

COPY . /app

RUN mix compile

ENTRYPOINT /app/entrypoint.sh