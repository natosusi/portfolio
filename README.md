# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

## 初期構築

1. library-record 配下に.env に API_KEY コピー
2. docker compose run webapp bundle install
3. docker compose build
4. docker compose run --rm webapp rails assets:precompile
5. docker compose run webapp rails db:reset
6. docker compose up

ほげほげ
