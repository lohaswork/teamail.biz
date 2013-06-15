#!/bin/bash
bundle install
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
elif
  echo 'tailor check has passed.'
fi

metric_fu -r
