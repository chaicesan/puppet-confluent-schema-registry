# Setup the server and ensure its state
class confluent_schema_registry::service {
  service { 'schema_registry':
    ensure     => running,
    name       => 'schema-registry',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
