# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings
#################################

# NOTE: Remember to run "vagrant reload" after changing any of these

# IP Address for the host only network, change it to anything you like
# but please keep it within the IPv4 private network range
ip_address = "175.55.55.55" ### ALWAYS CHECK IT ###

# The project name is base for directories, hostname and alike
project_name = "mage_project"
# begin danger part. this part is better leave as it is ;)
project_www_name = project_name + ".local"
project_www_aliases = [ "www." + project_www_name]
project_root = "/var/www/" + project_name
project_www = project_root + "/magento"
# end danger part

# MySQL and PostgreSQL password - feel free to change it to something
# more secure
database_password = "root"

# Magento configuration
#
### magento version ###
  #1.8.1.0 #1.7.0.2 #1.7.0.1 #1.7.0.0 #1.6.2.0 #1.6.1.0 #1.6.0.0 #1.5.1.0 #1.5.0.1
mage_version = '1.5.1.0';
mage_locale = 'pt_BR';
mage_timezone = 'America/Sao_Paulo';
mage_default_currency = 'BRL';
mage_db_host = "localhost";
mage_db_user = "user_mage";
mage_db_pass = "pass_mage";
mage_db_name = "db_mage";
mage_db_prefix = "m_";
mage_url = "http://" + project_www_name + "/";
mage_use_rewrites = 'true';
mage_use_secure = 'no';
mage_secure_base_url = mage_url; # change if needed
mage_use_secure_admin = "no";
mage_skip_url_validation = "yes";
mage_admin_firstname = 'Store';
mage_admin_lastname = 'Admin';
mage_admin_email = 'admin@email.com';
mage_admin_username = 'admin';
mage_admin_password = 'admin123'; # must be at least of 7 characters and include both numeric and alphabetic characters.

# Vagrant configuration
#################################

Vagrant.configure("2") do |config|

  # Define VM box to use
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Set share folder
  config.vm.synced_folder "./" , project_root + "/", :mount_options => ["dmode=777", "fmode=666"]

  # Use hostonly network with a static IP Address and enable
  # hostmanager so we can have a custom domain for the server
  # by modifying the host machines hosts file
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.define project_name do |node|
    node.vm.hostname = project_www_name
    node.vm.network :private_network, ip: ip_address
    node.hostmanager.aliases = project_www_aliases
  end
  config.vm.provision :hostmanager

  # ADDITIONAL CONFIGURATIONS

  # Set the timezone
  config.vm.provision :shell, :inline => "echo \"EST\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  # Use VBoxManage to customize the VM
  config.vm.provider :virtualbox do |vb|
    # increase virtual machine memory
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    #vb.customize ["modifyvm", :id, "--memory", "2048"]
    # vb.customize ["modifyvm", :id, "--memory", "4096"]
    #vb.customize ["modifyvm", :id, "--memory", "9192"]
  end


  # PUPPET CONFIGS

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest file
  # in the manifests_path directory.
  config.vm.provision :puppet do |puppet|
  #  puppet.pp_path = "/tmp/vagrant-puppet"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "base.pp"
    puppet.module_path    = "puppet/modules"
    #puppet.options = "--verbose --debug"
    ## custom facts provided to Puppet
    puppet.facter = {
      "project_name" => project_name,
      "project_root" => project_root,
      "project_www" => project_www,
      "project_www_name" => project_www_name,
      "database_password" => database_password,

      "mage_version" => mage_version,
      "mage_locale" => mage_locale,
      "mage_timezone" => mage_timezone,
      "mage_default_currency" => mage_default_currency,
      "mage_db_host" => mage_db_host,
      "mage_db_user" => mage_db_user,
      "mage_db_pass" => mage_db_pass,
      "mage_db_name" => mage_db_name,
      "mage_db_prefix" => mage_db_prefix,
      "mage_url" => mage_url,
      "mage_use_rewrites" => mage_use_rewrites,
      "mage_use_secure" => mage_use_secure,
      "mage_secure_base_url" => mage_secure_base_url,
      "mage_use_secure_admin" => mage_use_secure_admin,
      "mage_skip_url_validation" => mage_skip_url_validation,
      "mage_admin_firstname" => mage_admin_firstname,
      "mage_admin_lastname" => mage_admin_lastname,
      "mage_admin_email" => mage_admin_email,
      "mage_admin_username" => mage_admin_username,
      "mage_admin_password" => mage_admin_password
    }
  end

end
