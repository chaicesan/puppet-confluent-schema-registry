# Setup configuration files for Schema Registry
class confluent_schema_registry::config (
  $port                                = '8081',
  $debug                               = false,
  $kafkastore_connection_url           = 'localhost:2181',
  $zk_namespace                        = $confluent_schema_registry::zk_namespace,
  $group_id                            = $confluent_schema_registry::group_id,
  $master_eligibility                  = true,
  $unclean_leader_election_enable      = false,
  $kafkastore_topic                    = '_schemas',
  $kafkastore_topic_replication_factor = '3',
  $kafkastore_commit_interval_ms       = '-1',
  $kafkastore_init_timeout_ms          = '5000',
  $kafkastore_timeout_ms               = '500',
  $kafkastore_zk_session_timeout_ms    = '10000',
  $avro_compatibility_level            = 'full',
  $metric_reporters                    = '',
  $metrics_jmx_prefix                  = 'kafka.schema.registry',
  $metrics_num_samples                 = '2',
  $metrics_sample_window_ms            = '30000',
  $request_logger_name                 = 'io.confluent.rest-utils.requests',
  $shutdown_graceful_ms                = '1000',
) {
  file {
    '/etc/schema-registry/schema-registry.properties':
      content => template('confluent_schema_registry/schema-registry.properties.erb'),
      owner   => 'schema-registry',
      group   => 'schema-registry',
      mode    => '0644',
      notify  => Service['schema-registry'];
    '/etc/schema-registry/log4j.properties':
      content => template('confluent_schema_registry/log4j.properties.erb'),
      owner   => 'schema-registry',
      group   => 'schema-registry',
      mode    => '0644',
      notify  => Service['schema-registry'];
  }
}
