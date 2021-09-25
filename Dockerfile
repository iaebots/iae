FROM ruby:3.0.0-alpine

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Requirements for Rails app
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      tzdata \
      yarn \
      imagemagick \
      ffmpeg

ENV BUNDLER_VERSION=2.2.26
ENV BUNDLE_JOBS 8
ENV BUNDLE_RETRY 5
ENV BUNDLE_WITHOUT development:test
ENV BUNDLE_CACHE_ALL true
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true

RUN gem install bundler -v $BUNDLER_VERSION

WORKDIR /app

# Gems installation
COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

# NPM packages installation
COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile --non-interactive --production

COPY . ./
