
FROM elixir:latest

RUN apt-get update && \
    apt-get install -y inotify-tools && \
    mix archive.install hex phx_new && \
    mix local.hex --force && \
    mix local.rebar --force

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME