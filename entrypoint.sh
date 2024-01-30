#!/bin/bash
set -e

rm -f /weather/tmp/pids/server.pid

bundle
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

exec "$@"
