# Since we use CDH parcels instead of packages and since the Hadoop roles of each node are decided by Devs,
# we need a dynamic way of knowing whether or not a host is running the impala daemon (useful in the manifests to allow the process with rkhunter)
#
# 2015-08-21 epetrini@collectivei.com Initial Release

Facter.add('ccm_cdh_impala') do
  confine :kernel => "Linux"
  setcode do
    %x(/usr/bin/pgrep -fl impalad | awk '$2 ~ /impalad/ { print $2 }')
  end
end