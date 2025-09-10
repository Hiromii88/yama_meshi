# syntax = docker/dockerfile:1
FROM ruby:3.2.9-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates \
    libpq-dev postgresql-client \
    libyaml-dev \
    libxml2-dev libxslt1-dev \
    nodejs npm \
    libvips \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

ARG BUNDLER_VERSION=2.4.19
RUN gem install bundler -v ${BUNDLER_VERSION}

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_FORCE_RUBY_PLATFORM=1

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle lock --add-platform aarch64-linux || true

RUN bundle install

COPY . .

RUN mkdir -p tmp/pids

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
