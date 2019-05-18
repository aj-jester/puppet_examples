#!/bin/bash
# Check https://crosscommercemedia.jira.com/browse/SM-1517 for details

# this is intended only for production. Please ensure this is only run on one of the ES hosts.
# this script requires a snapshot repository. https://www.elastic.co/guide/en/elasticsearch/reference/6.1/modules-snapshots.html
# the snapshot repository must be mounted on all elastic nodes in a cluster.

es_host=localhost
index=cinews
day=$(date +%a|tr '[A-Z]' '[a-z]') # mon, tue, wed, thu, fri, sat, sun

# Instead of dealing with json in bash we just DELETE cinews_$day and recreate it
curl -s -XDELETE http://$es_host:9200/_snapshot/nfs_backup/${index}_${day}
curl -s -XPUT http://$es_host:9200/_snapshot/nfs_backup/${index}_${day} -H'Content-Type: application/json' -d '{ "indices": "'${index}'" }'
