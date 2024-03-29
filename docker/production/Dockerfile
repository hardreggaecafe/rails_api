# == base
FROM ruby:3.1.3-alpine3.15 AS base

WORKDIR /app
ENV RAILS_ENV production
ENV BUNDLE_DEPLOYMENT true
ENV BUNDLE_PATH vendor/bundle
ENV BUNDLE_WITHOUT development:test

RUN gem install bundler --no-document --version 2.3.26

# == builder
FROM base AS builder

# Add packages
RUN apk update && apk add --no-cache --update \
      build-base \
      mysql-dev \
      tzdata \
      git \
      yarn \
      shared-mime-info

# == bundle
FROM builder AS bundle

# Install gems
COPY Gemfile Gemfile.lock .
RUN bundle install \
      && rm -rf $BUNDLE_PATH/ruby/$RUBY_VERSION/cache/*

# == npm
FROM builder AS npm

# Install npm packages
#COPY package.json yarn.lock .
RUN yarn install --production --frozen-lockfile \
      && yarn cache clean

# == assets
FROM builder AS assets

COPY . .

COPY --from=bundle /app/vendor/bundle /app/vendor/bundle
COPY --from=npm /app/node_modules node_modules

# Set a dummy value to avoid errors when building docker image.
# refs: https://github.com/rails/rails/issues/32947
#RUN SECRET_KEY_BASE=dummy bin/rails assets:precompile \
#      && rm -rf tmp/cache/*
RUN SECRET_KEY_BASE=dummy rm -rf tmp/cache/*

# == main
FROM base AS main

# Add packages
RUN apk update && apk add --no-cache --update \
      mysql-dev \
      tzdata \
      nodejs \
      shared-mime-info

COPY . .

# Copy files from each stages
COPY --from=bundle /app/vendor/bundle /app/vendor/bundle
#COPY --from=assets /app/public/assets public/assets
#COPY --from=assets /app/public/packs public/packs

ARG SHA
ENV SHA ${SHA}
ENV PORT 80
EXPOSE 80

CMD bin/rails server --port $PORT
