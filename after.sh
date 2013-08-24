#!/bin/bash
BUILD_RESULT=$(curl -s http://58.246.35.174/jenkins/job/lohaswork/$BUILD_NUMBER/api/xml?xpath=/freeStyleBuild/result)

if [[ $BUILD_RESULT != "SUCCESS" ]]; then
  curl --sslv3 "https://api.github.com/repos/lohaswork/LohasWork.com/issues?access_token=e9055c6eb3648094c1bf8f970095798f90780141" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{
    "title": "Last CI fail",
    "body": "CI result: **Failure** [build info](http://58.246.35.174/jenkins/job/lohaswork/)",
    "labels": ["discussion"]
  }'
fi
