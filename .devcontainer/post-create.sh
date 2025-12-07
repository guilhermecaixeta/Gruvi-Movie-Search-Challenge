#!/bin/bash

# Install the version of Bundler specified in Gemfile.lock
if [ -f Gemfile.lock ]; then
    bundler_version=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d ' ')
    gem update --system 4.0.0
    gem install bundler -v "$bundler_version"
fi

# If there's a Gemfile, then run `bundle install`
if [ -f Gemfile ]; then
    echo "Installing gems"
    gem install rails sorbet foreman debug rdbg kamal ruby-debug-ide debase gem rubocop-rails-omakase

    echo "running bundle"
    bundle install
fi
