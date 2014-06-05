class apache2(
        $project_root,
        $project_www,
        $project_name,
        $project_www_name
    ) {

    package { 'apache2':
        ensure => installed,
        before => File['/etc/apache2/sites-available/default'],
    }

    file { '/etc/apache2/sites-available/default':
        ensure  => file,
        content => template('apache2/vhost_default.erb'),
    }

    service { 'apache2':
        ensure  => 'running',
        subscribe => File['/etc/apache2/sites-available/default'],
    }
}
