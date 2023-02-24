FROM ruby:3.1

WORKDIR /rails_mysql_pj

COPY Gemfile /rails_mysql_pj/Gemfile
COPY Gemfile.lock /rails_mysql_pj/Gemfile.lock

RUN bundle lock --add-platform ruby
#RUN bundle lock --add-platform x86_64-linux

RUN bundle install
RUN bundle update

COPY . /rails_mysql_pj

