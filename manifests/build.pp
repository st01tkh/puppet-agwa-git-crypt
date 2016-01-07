class agwa-git-crypt::build {
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
      class {'agwa-git-crypt::deps': }

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

      $msys_ssl_inc = file_join_win(["${msys_dir}", "include", "openssl"])
      $mingw_ssl_inc = file_join_win(["${mingw_dir}", "include", "openssl"])
      notify {"msys_ssl_inc: ${msys_ssl_inc} mingw_ssl_inc: ${mingw_ssl_inc}": }
      file {"${mingw_ssl_inc}":
        require => [
          Class['agwa-git-crypt::deps'],
        ],
        ensure => 'link',
        target => "${msys_ssl_inc}",
      }
      #file { "ensure_${tmp_dir}":
      #  ensure => directory
      #}
      vcsrepo { "${$tmp_path}":
        #require => [File["ensure_${tmp_dir}"]],
        ensure   => present,
        provider => git,
        source => 'https://github.com/AGWA/git-crypt',
      }
      $msys_lib = file_join_win(["${msys_dir}", "lib"])
      $mingw_lib = file_join_win(["${mingw_dir}", "lib"])
      exec {"make_git-crypt": 
        path => [$sysroot, $sys32, $mingw_bin, $msys_bin],
        cwd => "${tmp_path}",
        environment => ["LIBRARY_PATH=${msys_lib};${mingw_lib}"],
        command => "make"
      }
    }
    default: {
      notify {'No action by default':}
    }
  }
}
