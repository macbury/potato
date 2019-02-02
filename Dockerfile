# Base docker image for running all tests and deploys

FROM ubuntu:16.04

SHELL ["/bin/bash", "--login", "-c"]

ENV container docker
ENV RAILS_ENV production
ENV BASH_ENV /etc/profile
ENV DEBIAN_FRONTEND noninteractive
ENV SECRET_KEY_BASE 'abc'

COPY .docker/potato/profile /root/.profile
COPY .docker/potato/bashrc /root/.bashrc

RUN mkdir -p /app
WORKDIR /app
STOPSIGNAL SIGRTMIN+3

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Basic stuff
RUN apt-get update && apt-get install -y git build-essential libpq-dev

# Setup asdf for managing ruby and node versions
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.6.0
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> $BASH_ENV
RUN echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> $BASH_ENV

RUN asdf plugin-add nodejs
RUN asdf plugin-add ruby
RUN bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
RUN apt-get install -y libssl-dev libreadline-dev zlib1g-dev curl wget

# Cleanup unused stuff
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN asdf install ruby 2.5.0
RUN asdf install nodejs 10.13.0

RUN asdf global ruby 2.5.0
RUN asdf global nodejs 10.13.0

RUN gem install bundler
RUN curl -o- -L https://yarnpkg.com/install.sh | bash

ENV TZ 'Europe/Warsaw'
RUN echo $TZ > /etc/timezone && \
      apt-get update && apt-get install -y tzdata && \
      rm /etc/localtime && \
      ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
      dpkg-reconfigure -f noninteractive tzdata && \
      apt-get clean

COPY . /app
RUN cp .env.example .env
RUN bundle install
RUN yarn
RUN rake tmp:create assets:precompile
RUN rm .env

COPY bin/server /app/bin
RUN chmod +x bin/server

EXPOSE 3000

ENV RAILS_LOG_TO_STDOUT true

CMD ["/bin/bash", "-l", "-c", "exec bin/server"]