class couchdb::backup {

  require couchdb
  require python

  # used in ERB templates
  $bind_address = $couchdb::bind_address
  validate_re($bind_address, '^\S+$')
  $port = $couchdb::port
  validate_re($port, '^[0-9]+$')
  $backupdir = $couchdb::backupdir
  validate_absolute_path($backupdir)

  $admin_user = $couchdb::config::admin_username ? {
    undef => 'None',
    default => "'${couchdb::config::admin_username}'",
  }

  $admin_password = $couchdb::config::admin_password ? {
    undef => 'None',
    default => "'${couchdb::config::admin_password}'",
  }

  file {$backupdir:
    ensure  => directory,
    mode    => '0755',
    require => Package['couchdb'],
  }

  file { '/usr/local/sbin/couchdb-backup.py':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('couchdb/couchdb-backup.py.erb'),
    require => File[$backupdir],
  }

  cron { 'couchdb-backup':
    command => '/usr/local/sbin/couchdb-backup.py 2> /dev/null',
    hour    => 3,
    minute  => 0,
    require => File['/usr/local/sbin/couchdb-backup.py'],
  }

  python::pip { ['couchdb', 'simplejson']:
    proxy => hiera('https_proxy'),
  }

}
