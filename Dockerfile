FROM ruby:3.0.0-alpine

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Requirements for Rails app
RUN apk add --no-cache --update build-base \
  linux-headers \
  git \
  postgresql-dev \
  postgresql \
  postgresql-client \
  nodejs \
  yarn \
  python2 \
  tzdata \
  imagemagick \
  libxml2-dev \
  libxslt-dev \
  libgcrypt-dev \
  vim

ENV BUNDLER_VERSION=2.2.21
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

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]