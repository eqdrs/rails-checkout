FROM ruby:2.6.1

RUN apt-get update
RUN apt-get install -y nodejs

RUN mkdir /vendas
WORKDIR /vendas

ADD Gemfile /vendas
ADD Gemfile.lock /vendas

RUN bundle install

ADD . /vendas

CMD ["bundle", "exec", "rails", "console"]