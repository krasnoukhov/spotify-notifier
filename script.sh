#!/usr/bin/env bash

echo "Running..."
export LANG=en_US.UTF-8
cd /application
/usr/local/bin/bundle --quiet
source .env
/usr/local/bin/ruby spotify-notifier.rb
