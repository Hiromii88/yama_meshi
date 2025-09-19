# syntax = docker/dockerfile:1
FROM ruby:3.2.9-slim

# Node.js 20.x を入れる（Tailwind v4 に対応させるため）
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

# bundler
ARG BUNDLER_VERSION=2.4.19
RUN gem install bundler -v ${BUNDLER_VERSION}

# 環境変数
ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR /app

# Gemfile 先にコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle lock --add-platform x86_64-linux || true
RUN bundle install --without development test

# Node の依存関係をインストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile || true

# アプリコードコピー
COPY . .

# Tailwind / Asset をビルド
RUN yarn build:css
# Rails assets precompile（ダミー値を渡す）
RUN SECRET_KEY_BASE=DummyValue bundle exec rails assets:precompile

# tmp ディレクトリ作成
RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
