puppet-bamboo
=============

Puppet module for managing Atlassian Bamboo on Debian and Ubuntu.

# Installation #

Clone this repository in /etc/puppet/modules, but make sure you clone it as directory
'bamboo':

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-bamboo.git bamboo

You also need the puppet-tomcat project:

	cd /etc/puppet/modules
	git clone https://github.com/jurgenlust/puppet-tomcat.git tomcat
	
# Usage #

The manifest in the tests directory shows how you can install Bamboo.
For convenience, a Vagrantfile was also added, which starts a
Debian Squeeze x64 VM and applies the init.pp. When the virtual machine is ready,
you should be able to access bamboo at
[http://localhost:8580/bamboo](http://localhost:8580/bamboo).

Note that the vagrant VM will only be provisioned correctly if the bamboo
and tomcat modules are in the same parent directory.
	