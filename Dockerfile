FROM ruby:slim

WORKDIR /usr/app

RUN apt-get update \
 && apt-get install -y jq git \ 
 && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local without 'development' && \
  bundle install

COPY lib lib

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]

