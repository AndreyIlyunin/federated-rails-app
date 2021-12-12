FROM ruby:3.0.1-alpine

ENV BUNDLER_VERSION=2.2.19

RUN apk add --update --no-cache \
      tzdata \
      build-base \
      libxml2-dev \
      libxslt-dev \
      mariadb-dev \
      sqlite-dev

RUN gem install bundler -v $BUNDLER_VERSION

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

EXPOSE 3000

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
