# Elasticsearch role - Google Cloud Testing Edition
class ccm_role::gce_es {

  # Pull in our Elastic Moules for this role
  include ccm_elastic::search

}
