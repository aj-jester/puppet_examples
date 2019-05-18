# Since we use CDH parcels instead of packages and since the Hadoop roles of each node are decided by Devs,
# we need a dynamic way of knowing whether or not a host is running the impala catalog server and which dir it uses
#
# 2015-12-14 epetrini@collectivei.com Initial Release

Facter.add('ccm_cdh_impala_catalog_server_dir') do
  confine :kernel => "Linux"
  confine :tier => "site"
  confine :role => %w{cdh cdhadmin}
  setcode do
    `ps aux | grep catalog[d] | awk -F= '{print $NF}'`.split('/').take(6).join("/")
  end
end