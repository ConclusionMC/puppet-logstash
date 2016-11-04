# == Class: logstash::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
# * Matthias Baur <mailto:matthias.baur@dmc.de>
#
class logstash::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # service status
  $status = 'enabled'

  # restart on configuration change?
  $restart_on_change = true

  # Purge configuration directory
  $purge_configdir = false

  $purge_package_dir = false

  # package download timeout
  $package_dl_timeout = 600 # 300 seconds is default of puppet

  # default version to use if none is provided when manage_repo is set to true
  $repo_version = '5.x'

  #### Internal module values

  # User and Group for the files and user to run the service as.
  case $::kernel {
    'Linux': {
      $logstash_user  = 'root'
      $logstash_group = 'root'
    }
    'Darwin': {
      $logstash_user  = 'root'
      $logstash_group = 'wheel'
    }
    default: {
      fail("\"${module_name}\" provides no user/group default value
           for \"${::kernel}\"")
    }
  }

  # Download tool

  case $::kernel {
    'Linux': {
      $download_tool = 'wget --no-check-certificate -O'
    }
    'Darwin': {
      $download_tool = 'curl -o'
    }
    default: {
      fail("\"${module_name}\" provides no download tool default value
           for \"${::kernel}\"")
    }
  }

  # Different path definitions
  case $::kernel {
    'Linux': {
      $configdir = '/etc/logstash'
      $package_dir = '/var/lib/logstash/swdl'
      $installpath = '/opt/logstash'
      $plugin = '/usr/share/logstash/bin/plugin'
    }
    'Darwin': {
      $configdir = '/Library/Application Support/Logstash'
      $package_dir = '/Library/Logstash/swdl'
      $installpath = '/Library/Logstash'
      $plugin = '/Library/Logstash/bin/plugin'
    }
    default: {
      fail("\"${module_name}\" provides no config directory default value
           for \"${::kernel}\"")
    }
  }
  $patterndir = "${configdir}/patterns"
  $plugindir = "${configdir}/plugins"

  # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux', 'SLES', 'OpenSuSE': {
      # main application
      $package = [ 'logstash' ]
      $package_name = 'logstash'
    }
    'Debian', 'Ubuntu': {
      # main application
      $package = [ 'logstash' ]
      $package_name = 'logstash'
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }
}
