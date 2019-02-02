# Building

```
apt-get update

apt-get install -y libssl-dev libreadline-dev zlib1g-dev libpq-dev curl
asdf install ruby 2.5.0
asdf global ruby 2.5.0

asdf install nodejs 10.13.0
asdf global nodejs 10.13.0

gem install bundler --no-ri --no-rdoc
curl -o- -L https://yarnpkg.com/install.sh | bash
curl -L https://gist.githubusercontent.com/rtgkurel/082a7142ae55d4dfbbe121df9347d1e4/raw/chromedrv-install.sh | sudo bash -s 2.42
apt-get update && apt-get install postgresql postgresql-contrib redis-server -y

sudo -u postgres psql -c "UPDATE pg_database SET datistemplate=FALSE WHERE datname='template1';"
sudo -u postgres psql -c "DROP DATABASE template1;"
sudo -u postgres psql -c "CREATE DATABASE template1 WITH owner=postgres template=template0 encoding='UTF8';"
sudo -u postgres psql -c "UPDATE pg_database SET datistemplate=TRUE WHERE datname='template1';"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"

cp .env.example .env
bundle install --path vendor/gems
yarn

RAILS_ENV=test bundle exec rake db:create db:migrate

```

# TODO

* edit project scripts
  * trigger build
  * add image
  * remove image
  * select base image
* edit pipeline
  * add pipeline
  * remove pipeline
  * save script
* edit ssh keys
* edit env keys
* load more for projects
* load more for builds
* list all builds
* Deploy stuff
* Webhook that creates build
* update build status on github
* speed up ansi rendering

# UI

* https://github.com/bleenco/abstruse/blob/1491898cc4ecb3c2c2f45b45396ed4e4269d7074/src/api/process.ts#L105
* projects https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=ngrok&starCount=0

# Basic concepts

* Installation should only require user to pull docker image and create basic configuration file
* UI is simple and basic as hell
* Each test is run inside a separate docker container
* Integration with github

## Steps

* Build image - add commands to docker file and build image used in next steps
* Preapre container - container clone stuff to /app directory, run each per pipeline(stuff like bundle install, db create, migrate) before running test command
* Main test - commands to run in the pipeline(bundle exec rspec for example)
* Deploy - (before this step run prepare container)if enabled trigger commands specified for this step in project directory

## Basic image

* ubuntu with systemd
* asdf for managing languages

## Example script

```yaml
git: 'git@github.com:macbury/potato.git'
env:
  RAILS_ENV: test
  BRANCH: # this is auto completed by potato
trigger:
  - type: push
    branch: /*.*/
  - type: time
    cron: '0 */3 * * *'
    branch: 'master'
build:
  - image: alpine-ruby
    commands:
      - apt-get update
      - apt-get install this
prepare:
  - bundle install
  - rake db:create db:migrate db:seed
  - yarn
pipelines:
  - name: rspec
    commands:
      - bundle exec rspec
  - name: jest
    commands:
      - yarn test
deploy:
  - branch: 'master'
    commands:
      bundle exec cap $branch deploy
```

## Installation

```
bundle install
rake db:create db:migrate docker:build
```

## Reference

* https://github.com/cytopia/awesome-ci/blob/master/README.md
* https://developer.github.com/v3/guides/building-a-ci-server/
* https://docs.docker.com/engine/api/v1.37/
* https://www.iconfinder.com/icons/1760341/chip_potato_chip_snack_icon
* https://hub.docker.com/r/solita/ubuntu-systemd/
