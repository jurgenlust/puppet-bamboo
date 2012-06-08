puppet-bamboo
=============

Puppet module for managing Atlassian Bamboo on Debian and Ubuntu.

# Installation #

Clone this repository in /etc/puppet/modules, but make sure you clone it as directory
'bamboo':

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-bamboo.git bamboo

You also need the puppet-tomcat module:

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-tomcat.git tomcat
	
To run the example Vagrant machine, you also need the puppet-postgres module:

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-postgres.git postgres

	
# Usage #

The manifest in the tests directory shows how you can install Bamboo.
For convenience, a Vagrantfile was also added, which starts a
Debian Squeeze x64 VM and applies the init.pp. When the virtual machine is ready,
you should be able to access bamboo at
[http://localhost:8580/bamboo](http://localhost:8580/bamboo).

Note that the vagrant VM will only be provisioned correctly if the bamboo,
tomcat and postgres modules are in the same parent directory.
	