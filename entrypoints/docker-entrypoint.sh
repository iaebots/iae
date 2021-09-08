#!/bin/sh

unset BUNDLE_PATH
unset BUNDLE_BIN

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle install
bundle exec rails db:migrate
bundle exec rails s -b 0.0.0.0