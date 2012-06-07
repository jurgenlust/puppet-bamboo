include tomcat
include postgres

postgres::user { 'bamboo': 
	username => 'bamboo',
	password => 'bamboo',
}

postgres::db { 'bamboo':
	name => 'bamboo',
	owner => 'bamboo'
}

class { "bamboo": 
	require => Postgres::Db['bamboo'],
}
