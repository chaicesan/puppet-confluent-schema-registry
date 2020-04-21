# Class to install packages and optionally setup repos to fetch them from.
class confluent_schema_registry::install {

  include apt

  apt::source { 'confluent':
    location          => "http://packages.confluent.io/deb/${confluent_schema_registry::confluent_release}",
    release           => 'stable main',
    architecture      => 'all',
    repos             => '',
    required_packages => 'debian-keyring debian-archive-keyring',
    key               => {
      'id'     => '1A77041E0314E6C5A486524E670540C841468433',
      'source' => "http://packages.confluent.io/deb/${confluent_schema_registry::confluent_release}/archive.key",
    },
    include           => {
      'deb' => true,
      'src' => false,
    },
  }

  -> apt::pin { 'confluent-schema-registry':
    packages => ['confluent-schema-registry','confluent-common','confluent-rest-utils'],
    version  => $confluent_schema_registry::version,
    priority => 1000,
  }

  package { ['confluent-schema-registry','confluent-common','confluent-rest-utils']:
    ensure => $::confluent_schema_registry::version,
  }

  group { 'schema-registry':
    ensure => present,
  }

  user { 'schema-registry':
    ensure  => present,
    shell   => '/bin/false',
    require => Group['schema-registry'],
  }

  file {
    '/etc/init.d/schema-registry':
      source => 'puppet:///modules/confluent_schema_registry/schema-registry.init',
      mode   => '0755';
    $::confluent_schema_registry::app_log_dir:
      ensure  => directory,
      owner   => 'schema-registry',
      group   => 'schema-registry',
      mode    => '0755',
      require => Package['confluent-schema-registry'];
  }
}
