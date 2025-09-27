# syntax = docker/dockerfile:1
FROM ruby:3.2.9-slim

# Node.js 20.x を入れる（v4動作に十分な新しいバージョン）
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates gnupg \
    libpq-dev postgresql-client \
    libyaml-dev \
    libxml2-dev libxslt1-dev \
    libvips \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs \
 && corepack enable \
 && rm -rf /var/lib/apt/lists/*

# bundler を指定バージョンで入れる
ARG BUNDLER_VERSION=2.4.19
RUN gem install bundler -v ${BUNDLER_VERSION}

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /app

# Gem を先にインストール
COPY Gemfile Gemfile.lock ./
RUN bundle lock --add-platform aarch64-linux || true
RUN bundle install

# Node の依存は package.json ができてからインストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile || true

# 残りのアプリケーションコードをコピー
COPY . .

RUN mkdir -p tmp/pids

EXPOSE 3000
CMD ["bin/dev"]
