FROM ruby:2.6.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
apt-get install -y nodejs && apt-get update -qq

WORKDIR /usr/venda/home

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN gem install bundler && bundle install

COPY . /usr/venda/home

CMD ["rails", "server", "-b", "0.0.0.0"]
