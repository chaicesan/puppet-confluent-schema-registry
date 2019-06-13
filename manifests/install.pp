# Class to install packages and optionally setup repos to fetch them from.
class confluent_schema_registry::install {
  case $::osfamily {
    'Debian': {
      if $::confluent_kafka::manage_repo and !defined(Apt::Source['confluent']) {

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
      }

      apt::pin { 'confluent-schema-registry':
        packages => ['confluent-schema-registry','confluent-common','confluent-rest-utils'],
        version  => $confluent_schema_registry::version,
        priority => 1000,
      }
    }

    'RedHat', 'CentOS': {
      if $::confluent_kafka::manage_repo {
        exec {
          "sudo rpm --import https://packages.confluent.io/rpm/${$confluent_schema_registry::confluent_release}/archive.key":
        }
        file {'/etc/yum.repos.d/confluent.repo':
          ensure  => present,
          content => epp('confluent_schema_registry/redhat/confluent.repo', $confluent_schema_registry::confluent_release),
        }
      }
    }

    default: {
      if $::confluent_kafka::manage_repo {
        notify{ 'We only support Debian or Redhat based systems.':}
      }
    }

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
