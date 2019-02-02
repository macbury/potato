# Base docker image for running all tests and deploys

FROM ubuntu:16.04

ENV container docker

RUN apt-get update && apt-get install -y locales locales-all
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV BASH_ENV /etc/profile
ENV SSH_AUTH_SOCK /tmp/.ssh-agent
ENV DISPLAY=:99

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "--login", "-c"]

# Install systemd
RUN apt-get update && apt-get install -y systemd

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN apt-get update && \
    apt-get install -y dbus

RUN systemctl set-default multi-user.target

COPY setup /sbin/

STOPSIGNAL SIGRTMIN+3

# Configure ssh agent socket path and agent socket
RUN apt-get update && apt-get install -y ssh

RUN mkdir /root/.ssh && ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Basic stuff
RUN apt-get update && apt-get install -y git build-essential

# Setup asdf for managing ruby and node versions
RUN git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.6.0
RUN echo -e '\n. $HOME/.asdf/asdf.sh' >> $BASH_ENV
RUN echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> $BASH_ENV

RUN asdf plugin-add nodejs
RUN asdf plugin-add ruby
RUN bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
RUN apt-get update && apt-get install -y libssl-dev libreadline-dev zlib1g-dev curl wget sudo unzip ca-certificates curl build-essential python xvfb x11vnc fluxbox xterm openssh-server

RUN git clone https://github.com/cytopia/awesome-ci.git /tmp/awesome-ci
RUN cd /tmp/awesome-ci && \
    ./configure && \
    make install

COPY profile /root/.profile
COPY bashrc /root/.bashrc
COPY scripts/ /usr/bin

RUN mkdir -p /app
WORKDIR /app

# Cleanup unused stuff
RUN apt-get clean

CMD ["/bin/bash", "-l", "-c", "exec /sbin/init --log-target=journal 3>&1"]
