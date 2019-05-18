#!/bin/bash
#
# Managed by Puppet
#
# Redis GET plugin
#

REDIS_CLI=`which redis-cli`

set -o nounset
set -o errexit

OUTPUT=$(echo "GET CI_Monitoring_check" | ${REDIS_CLI} -c)

if [[ ${OUTPUT} =~ "pong" ]]; then
  echo "OK: GET CI_Monitoring_check | get=2;1;0"
  exit 0
else
  echo "CRITICAL: GET CI_Monitoring_check | get=0;1;0"
  exit 2
fi
