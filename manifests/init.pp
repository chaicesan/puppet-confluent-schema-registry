# Setup Confluent's Schema Registry
class confluent_schema_registry (
  $confluent_release           = '1.0',
  $version                     = '1.0.1-2',
  $app_log_dir                 = '/var/log/schema-registry',
  # logger levels
  $kafka_loglevel              = 'INFO',
  $apache_zookeeper_loglevel   = 'WARN',
  $apache_kafka_loglevel       = 'WARN',
  $zkclient_loglevel           = 'WARN',
  $consumer_connector_loglevel = 'WARN',
  $zk_namespace                = undef,
  $group_id                    = undef,
) {
  class { 'confluent_schema_registry::install': }
  -> class { 'confluent_schema_registry::config':  }
  -> class { 'confluent_schema_registry::service': }
  -> Class['confluent_schema_registry']
}
