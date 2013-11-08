#!/bin/bash
#reek -n app

if [ -f config/database.yml ]; then
  echo 'config/database.yml already exists, so we will not replace it with config/database.yml.template'
else
  echo 'replace with config/database.yml.template'
  cp config/database.yml.template config/database.yml
fi

bundle install --path vendor/bundle
if [ $? -ne 0 ]; then
  echo 'bundle install error!'
  exit 1
fi
echo 'bundle install success.'

bundle exec rake db:migrate
if [ $? -ne 0 ]; then
  echo 'bundle exec rake db:migrate error!'
  exit 1
fi
echo 'bundle exec rake db:migrate success.'

bundle exec rake db:test:prepare

RAILS_ENV=test bundle exec rspec
if [ $? -ne 0 ]; then
  echo 'bundle exec rspec error!'
  exit 1
fi
echo 'bundle exec rspec success.'

bundle exec tailor
if [ $? -ne 0 ]; then
  echo 'tailor has warning or error!'
  exit 1
else
  echo 'tailor check has passed.'
fi

