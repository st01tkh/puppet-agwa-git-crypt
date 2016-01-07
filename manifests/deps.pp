class agwa-git-crypt::deps {
  case $operatingsystem {
    'Solaris':          {
      notify {'No action for Solaris yet':}
    }
    'RedHat', 'CentOS': {
      notify {'No action for RedHat and/or CentOS yet':} 
    }
    /^(Ubuntu)$/:{
      include apt
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
      include apt
      notify {'No action for Debian yet':}
    }
    'windows': {
      include mingw
      mingw::get::install {'msys': }
      mingw::get::install {'msys-make': }
      mingw::get::install {'mingw32-gcc': }
      mingw::get::install {'mingw32-gcc-g++': }
      mingw::get::install {'msys-openssl': }
      mingw::get::install {'msys-libopenssl': }
    }
    default: {
      notify {'No action by default':}
    }
  }
}
