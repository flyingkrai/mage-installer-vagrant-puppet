class magento(
        $version = '1.5.1.0',
        $locale = 'pt_BR',
        $timezone = 'America/Sao_Paulo',
        $default_currency = 'BRL',
        $db_host = 'localhost',
        $db_user = 'mydbuser',
        $db_pass = 'mysecret',
        $db_name = 'magentodb',
        $db_prefix,
        $url = 'http://project.local/',
        $use_rewrites = 'true',
        $use_secure = 'no',
        $secure_base_url = 'http://project.local/',
        $use_secure_admin = 'no',
        $skip_url_validation = 'yes',
        $admin_firstname = 'Store',
        $admin_lastname = 'Admin',
        $admin_email = 'admin@email.com',
        $admin_username = 'admin',
        $admin_password = 'admin'
    ) {

    exec { "create-magentodb-db":
        unless  => "/usr/bin/mysql -uroot -p${$mysql::root_pass} ${db_name}",
        command => "/usr/bin/mysqladmin -uroot -p${$mysql::root_pass} create ${db_name}",
        require => Service["mysql"],
    }

    exec { "grant-magentodb-db-all":
        unless  => "/usr/bin/mysql -u${db_user} -p${db_pass} ${db_name}",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_pass} -e \"grant all on *.* to ${db_user}@'%' identified by '${db_pass}' WITH GRANT OPTION;\"",
        require => [ Service["mysql"], Exec["create-magentodb-db"] ],
    }

    exec { "grant-magentodb-db-localhost":
        unless  => "/usr/bin/mysql -u${db_user} -p${db_pass} ${db_name}",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_pass} -e \"grant all on *.* to ${db_user}@'${db_host}' identified by '${db_pass}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"],
    }

    exec { "download-magento":
        cwd     => "/tmp",
        command => "/usr/bin/wget http://www.magentocommerce.com/downloads/assets/${version}/magento-${version}.tar.gz",
        creates => "/tmp/magento-${version}.tar.gz",
    }

    exec { "untar-magento":
        cwd     => $apache2::project_root,
        command => "/bin/tar xzf /tmp/magento-${version}.tar.gz",
        timeout => 600,
        require => Exec["download-magento"],
    }

    exec { "setting-permissions":
        cwd     => "${$apache2::project_www}",
        command => "/bin/chmod +x mage; /bin/chmod o+w var var/.htaccess app/etc; /bin/chmod -R 777 media",
        require => Exec["untar-magento"],
    }

    host { "${$apache2::project_name}":
        ip      => '127.0.0.1',
    }

    exec { "install-magento":
        cwd     => "${$apache2::project_www}",
        creates => "${$apache2::project_www}/app/etc/local.xml",
        command => "/usr/bin/php -f install.php -- \
            --license_agreement_accepted \"yes\" \
            --locale \"${locale}\" \
            --timezone \"${timezone}\" \
            --default_currency \"${default_currency}\" \
            --db_host \"${db_host}\" \
            --db_name \"${db_name}\" \
            --db_user \"${db_user}\" \
            --db_pass \"${db_pass}\" \
            --db_prefix \"${db_prefix}\" \
            --url \"${url}\" \
            --use_rewrites \"${use_rewrites}\" \
            --use_secure \"${use_secure}\" \
            --secure_base_url \"${secure_base_url}\" \
            --use_secure_admin \"${use_secure_admin}\" \
            --skip_url_validation \"${skip_url_validation}\" \
            --admin_firstname \"${admin_firstname}\" \
            --admin_lastname \"${admin_lastname}\" \
            --admin_email \"${admin_email}\" \
            --admin_username \"${admin_username}\" \
            --admin_password \"${admin_password}\"",
        require => [ Exec["setting-permissions"], Exec["create-magentodb-db"], Package["php5-cli"] ],
    }

    exec { "register-magento-channel":
        cwd     => "${$apache2::project_www}",
        onlyif  => "/usr/bin/test `${$apache2::project_www}/mage list-channels | wc -l` -lt 2",
        command => "${$apache2::project_www}/mage mage-setup",
        require => Exec["install-magento"],
    }

    /*file { "/etc/apache2/sites-available/magento":
        source  => '/vagrant/puppet/modules/magento/files/vhost_magento',
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    file { "/etc/apache2/sites-enabled/magento":
        ensure  => 'link',
        target  => '/etc/apache2/sites-available/magento',
        require => Package["apache2"],
        notify  => Service["apache2"],
    }*/

    exec { "sudo a2enmod rewrite":
        require => Package["apache2"],
        notify  => Service["apache2"],
    }
}
