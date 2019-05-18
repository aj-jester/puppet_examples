class ccm_elastic::common (

  # Java
  $openjdk                  = undef,

  # Common accross multiple products
  $version                  = '6.1.0',
  $user                     = 'elkadmin',

  ## Elasticsearch Defaults
  $clustername              = 'sane_default',
  $config                   = { 'cluster.name' => 'sane_default',
                                'network.host' => '127.0.0.1',
                                'discovery.zen.ping.unicast.hosts' => [ '127.0.0.1' ]
                              },
  $init_defaults            = { 'ES_HEAP_SIZE' => '1g' },
  $es_data_dir              = '/vol1/elastic',
  $es_snapshot_host         = 'undefined',
  $es_jvm_options           = [
                                '-Xms2g',
                                '-Xmx2g',
                              ],
  $restart_on_change        = false,
  $curator                  = false,

  ## Logstash specific
  $logstash_settings          = {},
  $logstash_config_template   = 'default.erb',
  $logstash_jvm_options       = [
                                  '-Xms512m',
                                  '-Xmx512m',
                                ],
  $logstash_output_slack        = false,
  $logstash_environment         = undef,
  $logstash_slack_hook          = undef,
  $logstash_log4j_plugin        = undef,
  $logstash_restart_on_change   = false,
  $logstash_elasticsearch_hosts = [ "localhost:9200"],

  ## Kibana specific
  $kibana_config            = { 'server.port'                  => '8080',
                                'server.host'                  => '0.0.0.0',
                                'server.maxPayloadBytes'       => '1048576',
                                'server.name'                  => $::fqdn,
                                'elasticsearch.url'            => 'http://localhost:9200',
                                'elasticsearch.preserveHost'   =>  true,
                                'kibana.defaultAppId'          => 'home',
                                'elasticsearch.pingTimeout'    => '1500',
                                'elasticsearch.requestTimeout' => '30000',
                                'elasticsearch.shardTimeout'   => '0',
                                'elasticsearch.startupTimeout' => '5000',
                                'ops.interval'                 => '5000',
                                'i18n.defaultLocale'           => 'en',
                              },

  ## Filebeat Specific
  $filebeat_major              = '6',
  $filebeat_manage_repo        = false,
  $filebeat_spool_size         = 2048,
  $filebeat_outputs            = { 'logstash' => {
                                     'hosts' => [ 'localhost:5044', ],
                                     'loadbalance' => false,
                                   },
                                 }  
){


  # Yum Repo
  include ccm_repo::elastic

  # Ensure elkadmin user
  include ccm_elastic::install 

  # Install OpenJDK or Java 8 to support ES 6.x
  if $openjdk {
    class { 'ccm_java::common::openjdk':
      default_version => $openjdk  
    }
    ccm_java::openjdk { $openjdk: }
  } else {
    include ccm_java::eight
  }

  # Custom System Tune for ES 6.x
  ccm_profile::tuned { 'elasticsearch-6x': }

}
