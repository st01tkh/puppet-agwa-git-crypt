# == Class: agwa-git-crypt
#
# AGWA git-crypt
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# st01tkh <st01tkh@gmail.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class agwa-git-crypt {
  include apt
  case $operatingsystem {
    'Solaris':          {
      notify {'No action for Solaris yet':}
    }
    'RedHat', 'CentOS': {
      notify {'No action for RedHat and/or CentOS yet':} 
    }
    /^(Ubuntu)$/:{
      case $lsbdistcodename {
        'precise': {
        }
        'trusty': {
          #apt::ppa { 'ppa:avacariu/git-crypt': }
          apt::ppa { 'ppa:outsideopen/git-crypt': }
        }
      }
      package { 'git-crypt':  ensure => 'installed' }
    }
    /^(Debian)$/:{
      notify {'No action for Debian yet':}
    }
    default: {
      notify {'No action by default':}
    }
  }
}
