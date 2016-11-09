#!/usr/bin/env bash

export LANG=en_US.UTF-8
source /home/krasnoukhov/.rvm/environments/ruby-2.3.0
cd /home/krasnoukhov/spotify-notifier
bundle exec ruby spotify-notifier.rb
