# Class: couchdb
#
# This module installs and configures couchdb
#
# Parameters:
#
# [* bind_address *]
#   The address to let the couchdb service bind to.
#
# [* port *]
#   The port to let couchdb listen to.
#
# [* backupdir *]
#   The directory where to put the couchdb backups into. (Make sure the parent directory exists)
#
# [* public_fields *]
#   World-viewable user document fields (sets also the users_db_public option to true)
#
# [* admin_username *]
#   The admin username to be configured for CouchDB
#
# [* admin_password *]
#   The password in plaintext to be used by CouchDB
#
# [* salt *]
#   The salt to use for the password hash in the local.ini (prevents changing the hash on every run) 
#
# [* require_valid_user *]
#   Set this to true to only enable authenticated requests to the CouchDB
#
# [* authentication_realm *]
#   Set this to the name of the realm that CouchDB should output when sending the unauthorized response.
#
class couchdb (
  $bind_address = $couchdb::params::bind_address,
  $port = $couchdb::params::port,
  $backupdir = $couchdb::params::backupdir,
  $public_fields = $couchdb::params::public_fields,
  $admin_username = $couchdb::params::admin_username,
  $admin_password = $couchdb::params::admin_password,
  $salt = $couchdb::params::salt,
  $require_valid_user = $couchdb::params::require_valid_user,
  $authentication_realm = $couchdb::params::authentication_realm,
) inherits ::couchdb::params {

  case $::osfamily {
    'Debian': { include ::couchdb::debian }
    'RedHat': { include ::couchdb::redhat }
    default:  { fail "couchdb not available for ${::operatingsystem}" }
  }
}
