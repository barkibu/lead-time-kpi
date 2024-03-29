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

ENV PROJECT_NAME "App"
ENV CHANGE_TYPES "defect,tech_debt,feature"
ENV CHANGE_TYPE_DEFAULT "feature"
ENV CHANGE_TYPE_DEFECT_ALIASES "defect,bug,fix,hotfix"
ENV CHANGE_TYPE_TECH_DEBT_ALIASES "tech_debt,refactor"
ENV CHANGE_TYPES_IGNORED "translation,ignore-for-kpis"
ENV VERSION_REGEXP "\d+.\d+.\d+"