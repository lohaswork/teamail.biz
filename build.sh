#!/bin/bash
if [ -f config/database.yml ]; then
  echo 'config/database.yml already exists, so we will not replace it with config/database.yml.template'
else
  echo 'replace with config/database.yml.template'
  cp config/database.yml.template config/database.yml
fi

bundle install --deployment
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

bundle exec rake spec
if [ $? -ne 0 ]; then
  echo 'bundle exec rake spec error!'
  exit 1
fi
echo 'bundle exec rake spec success.'

#reek -n app
tailor app/**/*.rb
if [ $? -ne 0 ]; then
  echo 'tailor has warning or error!'
else
  echo 'tailor check has passed.'
fi

metric_fu -r
