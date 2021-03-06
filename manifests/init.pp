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
      Package { provider => chocolatey, }
      include chocolatey
      include mingw

      class {'agwa-git-crypt::build':
      }

      $tmp_dir = 'c:\temp'
      $tmp_base = 'agwa-git-crypt.123'
      $tmp_path = file_join_win(["${tmp_dir}", "${tmp_base}"])

      $sysroot = env("SYSTEMROOT")
      $sys32 = file_join_win(["${sysroot}", "System32"])

      $tools_dir = 'C:\tools'

      $mingw_dir = file_join_win(["${tools_dir}", "MinGW"])
      $mingw_bin = file_join_win(["${mingw_dir}", "bin"])

      $msys_dir = file_join_win(["${mingw_dir}", "msys", "1.0"])
      $msys_bin = file_join_win(["${msys_dir}", "bin"])

      $choco_dir = env("ChocolateyInstall")
      $choco_bin = file_join_win(["${choco_dir}", "bin"])


      $git_crypt_exe_dst_path = file_join_win(["${mingw_bin}", "git-crypt.exe"])
      $git_crypt_exe_src_path = file_join_win(["${tmp_path}", "git-crypt.exe"])

      file {"${git_crypt_exe_dst_path}":
        require => Class['agwa-git-crypt::build'],
        source_permissions => ignore,
        ensure => present,
        mode => 0755,
        source =>  "${git_crypt_exe_src_path}",
      }
    }
    default: {
      notify {'No action by default':}
    }
  }
}
