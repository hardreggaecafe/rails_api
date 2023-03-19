FROM ruby:3.1 as base

WORKDIR /rails_mysql_pj
ENV RAILS_ENV production
ENV BUNDLE_DEPLOYMENT true
ENV BUNDLE_PATH vendor/bundle
ENV BUNDLE_WITHOUT development:test
RUN gem update --system && gem install bundler:2.1.4

# builder
FROM base AS builder

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && \
    apt-get install -y build-essential vim libvips nodejs locales && \
    npm install -g yarn

# bundle
FROM builder AS bundle

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --retry=3 && rm -rf $BUNDLE_PATH/ruby/$RUBY_VERSION/cache/*

# nginx
RUN apt-get install -y nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
ADD docker/production/nginx.conf /etc/nginx/nginx.conf
RUN echo "example docker contena nginx"
ADD docker/production/entrypoint.sh /app/entrypoint.sh
ENTRYPOINT /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf

EXPOSE 80

RUN chmod +x /app/entrypoint.sh
