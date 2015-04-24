FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev qt5-default libqt5webkit5-dev
RUN mkdir /connect
WORKDIR /connect
ADD Gemfile /connect/Gemfile
ADD Gemfile.lock /connect/Gemfile.lock
RUN bundle install
ADD . /connect
