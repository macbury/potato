## Build base potato ci image

```bash
cd app/docker_essential
docker build . -t potato-base
docker tag potato-base macbury/potato-base:latest
docker push macbury/potato-base:latest
```

## Build potato app image

```bash
docker build . -t potato
docker tag potato macbury/potato:latest
docker push macbury/potato:latest
```

# Installing on server

Create docker compose file on the target server

```yaml
version: '3'
services:
  postgres:
    image: postgres:10
    restart: always
    ports:
      - 5432:5432
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      PGDATA: /data
    volumes:
      - ./postgresql:/data
  app:
    image: macbury/potato:latest
    restart: always
    ports:
      - 3000:3000
    environment:
      RAILS_SERVE_STATIC_FILES: 'true'
      RAILS_ENV: production
      SECRET_KEY_BASE: 'ABCDS'
      DATABASE_URL: "postgres://postgres:postgres@postgres:5432/potato_production"
  sidekiq:
    image: macbury/potato:latest
    restart: always
    environment:
      RAILS_SERVE_STATIC_FILES: 'true'
      RAILS_ENV: production
      SECRET_KEY_BASE: 'ABCDS'
      DATABASE_URL: "postgres://postgres:postgres@postgres:5432/potato_production"
```

and run these commands

```bash
docker-compose pull potato
docker-compose up -d
docker-compose run potato bash -l -c "bundle exec rake db:create db:migrate"
```
