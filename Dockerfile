FROM bitwalker/alpine-elixir-phoenix:1.9.0 as builder

ENV MIX_ENV test
RUN apk update && \
    apk --no-cache --update upgrade alpine-sdk && \
    apk --no-cache add alpine-sdk && \
    rm -rf /var/cache/**/*
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix format --check-formatted && \
    mix test

RUN cd assets/ && \
    npm install && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

RUN MIX_ENV=prod mix distillery.release

FROM alpine:3.10
RUN apk update && \
    apk add --no-cache bash openssl && \
    rm -rf /var/cache/**/*
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/waterwheel/ .
ENV PORT 80
EXPOSE 80
CMD ["bin/waterwheel", "foreground"]
