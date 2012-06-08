include tomcat
include postgres

postgres::user { 'bb_user': 
	username => 'bb_user',
	password => 'bamboo_secret_password',
}

postgres::db { 'bamboodb':
	name => 'bamboodb',
	owner => 'bb_user'
}

class { "bamboo": 
	user => "bamboo", #the system user that will own the Bamboo Tomcat instance
	database_name => "bamboodb",
	database_driver => "org.postgresql.Driver",
	database_driver_jar => "postgresql-9.1-902.jdbc4.jar",
	database_driver_source => "puppet:///modules/bamboo/db/postgresql-9.1-902.jdbc4.jar",
	database_url => "jdbc:postgresql://localhost/bamboodb",
	database_user => "bb_user",
	database_pass => "bamboo_secret_password",
	number => 5, # the Tomcat http port will be 8580
	version => "4.1", # the Bamboo version
	contextroot => "/",
	webapp_base => "/opt", # Bamboo will be installed in /opt/bamboo
	require => Postgres::Db['bamboodb'],
}
