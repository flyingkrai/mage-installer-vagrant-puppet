A **standalone Magento DevOps environment** built with [Vagrant](http://www.vagrantup.com/) and [Puppet](http://puppetlabs.com/) from a vanilla Ubuntu 12.04 LTS box.


## Getting Started

1. Install the those software on your **host** machine
 * Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 * Download and install [Vagrant](http://www.vagrantup.com/downloads.html)
 * Download and install [Vagrant Hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
 * Download and install [Git](http://git-scm.com/downloads)

2. Grab the mage-installer-vagrant-puppet code
 ```
 git clone https://github.com/flyingkrai/mage-installer-vagrant-puppet.git mage_project
 cd mage_project
 ```

3. Configure your magento installation in **Vagrantfile**
 ###### Project configuration
 * `ip_address` the guest machine IP
 * `project_name` this variable will define the site url and the folder inside */var/www*. Remember that the hostname should only contain letters, numbers,
hyphens or dots and it cannot start with a hyphen or dot.
 * `project_www_name` sets what url you will access from your **host** machine (e.g.: if you set ***project_name*** as  mage-project* the default url be the name plus "*.local*" -- *http://mage-project.local/*)
 * `project_www_aliases` an array with the project aliases
 * `project_root` the default is set to */var/www/**project_name***
 * `project_www` it uses ***project_root*** value and add a trailing */magento*. If you decide to change it remember to keep the trailing */magento*
 * `database_password` the MySQL root password

 ###### Magento configuration
 * `mage_version` available versions:
    * 1.8.1.0
    * 1.7.0.2
    * 1.7.0.1
    * 1.7.0.0
    * 1.6.2.0
    * 1.6.1.0
    * 1.6.0.0
    * 1.5.1.0
    * 1.5.0.1
 * `mage_locale` e.g.: pt_BR
 * `mage_timezone` e.g.: America/Sao_Paulo
 * `mage_default_currency` e.g.: BRL
 * `mage_db_host` the host that Magento will use to connect to MySQL, default is *localhost*
 * `mage_db_user` Magento's specific MySQL user
 * `mage_db_pass` Magento's specific MySQL password
 * `mage_db_name` Magento's specific MySQl database
 * `mage_db_prefix` it must start with a letter and can't have special characters
 * `mage_url` as default it preppends the *http://* and uses the ***project_www_name*** to set the url. If you change it for a string value instead, remember to match ***project_www_name***
 * `mage_use_rewrites` use or not url rewrite
 * `mage_use_secure` for developing is better to leave it as "no"
 * `mage_secure_base_url` it uses the ***mage_url***. If you are not using secure urls just leave as it is
 * `mage_use_secure_admin` for developing is better to leave as "no"
 * `mage_skip_url_validation` tells Magento to validate it's urls
 * `mage_admin_firstname` admin first name
 * `mage_admin_lastname` admin last name
 * `mage_admin_email` admin email, **must be a valid email**
 * `mage_admin_username` admin username
 * `mage_admin_password` admin password, **must be at least of 7 characters and include both alphabetic and numeric  characters**

4. Start the app!
 ```
 vagrant up
 ```

5. (Optional) For some reason the Puppet fails to run the ***mage*** script, but you can run it from the host machine. I will try to fix it later!
 ```
 cd /magento
 chmod +x mage
 ./mage mage-setup
 ```

## Security concerns

This virtual machine is configured to run locally so no security precautions were taken. Do not try to use it in production before taking those precautions!

## Virtual Machine Specifications

* Ubuntu 12.04 LTS (*precise32*)
* Apache 2.2.22
* MySQL 5.5.31
* PHP 5.3.10
* Composer

