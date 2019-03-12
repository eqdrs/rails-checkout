FROM ruby:2.6.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
apt-get install -y nodejs && apt-get update -qq

RUN useradd -ms /bin/bash venda

USER venda

WORKDIR /usr/venda/home

COPY . /usr/venda/home

USER root

RUN chown -R venda:venda /usr/venda/home && \
    chmod 744 /usr/venda/home/Gemfile.lock

USER venda

RUN gem install bundler && bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]
