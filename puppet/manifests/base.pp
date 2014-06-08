/**
 * Set defaults
 */
# set default path for execution
Exec { path => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin' }

/**
 * Run "apt-get update" before installing packages
 */
exec { 'apt-update':
    command => '/usr/bin/apt-get update --fix-missing'
}
Exec['apt-update'] -> Package <| |>


package { 'curl':
    ensure => 'present',
}

group { 'puppet':
    ensure => 'present',
}

class { 'apache2':
    project_root => $project_root,
    project_www => $project_www,
    project_name => $project_name,
    project_www_name => $project_www_name,
}

/**
 * MySQL config
 */
class { 'mysql':
    root_pass => $database_password
}

/**
 * Magento config
 */
class { 'magento':
    version => $mage_version,
    locale => $mage_locale,
    timezone => $mage_timezone,
    default_currency => $mage_default_currency,
    db_host => $mage_db_host,
    db_user => $mage_db_user,
    db_pass => $mage_db_pass,
    db_name => $mage_db_name,
    db_prefix => $mage_db_prefix,
    url => $mage_url,
    use_rewrites => $mage_use_rewrites,
    use_secure => $mage_use_secure,
    secure_base_url => $mage_secure_base_url,
    use_secure_admin => $mage_use_secure_admin,
    skip_url_validation => $mage_skip_url_validation,
    admin_firstname => $mage_admin_firstname,
    admin_lastname => $mage_admin_lastname,
    admin_email => $mage_admin_email,
    admin_username => $mage_admin_username,
    admin_password => $mage_admin_password
}

/**
 * Import modules
 */
include apt
include mysql
include apache2
include php5
include composer
include magento
