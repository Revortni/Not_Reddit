
FROM elixir:latest

RUN apt-get update && \
    apt-get install -y inotify-tools && \
    mix local.hex --force && \
    mix archive.install hex phx_new && \
    mix local.rebar --force \
    mix local.hex --force

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME