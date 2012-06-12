# Class: bamboo
#
# This module manages Atlassian Bamboo
#
# Parameters:
#
# Actions:
#
# Requires:
#
#	Class['tomcat']
#   Tomcat::Webapp[$username]
#
#   See https://github.com/jurgenlust/puppet-tomcat
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class bamboo (
	$user = "bamboo",	
	$database_name = "bamboo",
	$database_driver = "org.postgresql.Driver",
	$database_driver_jar = "postgresql-9.1-902.jdbc4.jar",
	$database_driver_source = "puppet:///modules/bamboo/db/postgresql-9.1-902.jdbc4.jar",
	$database_url = "jdbc:postgresql://localhost/bamboo",
	$database_user = "bamboo",
	$database_pass = "bamboo",
	$number = 5,
	$version = "4.1",
	$contextroot = "bamboo",
	$webapp_base = "/srv",
	$service_require = ''
){
# configuration	
	$war = "atlassian-bamboo-${version}.war"
	$download_url = "http://www.atlassian.com/software/bamboo/downloads/binary/${war}"
	$bamboo_dir = "${webapp_base}/${user}"
	$bamboo_home = "${bamboo_dir}/bamboo-home"
	
	$webapp_context = $contextroot ? {
	  '/' => '',	
      '' => '',
      default  => "/${contextroot}"
    }
    
    $webapp_war = $contextroot ? {
    	'' => "ROOT.war",
    	'/' => "ROOT.war",
    	default => "${contextroot}.war"	
    }
    
    $bamboo_service_require = $service_require ? {
    	'' => [File['bamboo-war'], File['bamboo-db-driver'], File[$bamboo_home]],
    	default => [File['bamboo-war'], File['bamboo-db-driver'], File[$bamboo_home], $service_require]
    }
    
# create bamboo-home    
	file { $bamboo_home:
		ensure => directory,
		mode => 0755,
		owner => $user,
		group => $user,
		require => Tomcat::Webapp::User[$user],
	}

# download the war file
	exec { "download-bamboo":
		command => "/usr/bin/wget -O ${bamboo_dir}/tomcat/webapps/${webapp_war} ${download_url}",
		require => Tomcat::Webapp::Tomcat[$user],
		creates => "${bamboo_dir}/tomcat/webapps/${webapp_war}",
		timeout => 1200,	
	}
	
# the database driver jar
	file { 'bamboo-db-driver':
		path => "${bamboo_dir}/tomcat/lib/${database_driver_jar}", 
		source => $database_driver_source,
		ensure => file,
		owner => $user,
		group => $user,
		require => Tomcat::Webapp::Tomcat[$user],
	}    

# the Bamboo war file
	file { 'bamboo-war':
		path => "${bamboo_dir}/tomcat/webapps/${webapp_war}", 
		ensure => file,
		owner => $user,
		group => $user,
		require => Exec["download-bamboo"],
	}

# manage the Tomcat instance
	tomcat::webapp { $user:
		username => $user,
		webapp_base => $webapp_base,
		number => $number,
		java_opts => "-server -Xms128m -Xmx512m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dbamboo.home=${bamboo_home}",
		server_host_config => template("bamboo/context.erb"),
		description => "Atlassian Bamboo",
		service_require => $bamboo_service_require,
		require => Class["tomcat"],
	}
}
