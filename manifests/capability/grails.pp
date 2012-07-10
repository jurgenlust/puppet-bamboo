define bamboo::capability::grails(
	$version = undef
) {
	if ($version) {
		$dist_version = $version
	} else {
		$dist_version = $title
	}
	$build = "grails-${dist_version}"
	$archive = "${build}.zip"
	$url = "http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/${archive}"
	$path = "/opt/grails-${dist_version}"
	
	if ! defined(Package["unzip"]) {
		package{ 'unzip':
			ensure => present,
		}
	}

	exec { "download-grails-${dist_version}":
		command => "/usr/bin/wget -O /tmp/${archive} ${url}",
		creates => "/tmp/${archive}",
		timeout => 1200,
		notify => Exec["extract-grails-${dist_version}"],	
	}

	file { "grails-archive-${dist_version}":
		path => "/tmp/${archive}", 
		ensure => file,
		require => Exec["download-grails-${dist_version}"],
	}
	
	exec { "extract-grails-${dist_version}":
		command => "/usr/bin/unzip ${archive} && mv ${build} ${path}",
		cwd => "/tmp",
		user => 'root',
		creates => $path,
		timeout => 1200,
		refreshonly => true,
		require => [
			File["grails-archive-${dist_version}"],
			Package['unzip']
		]
	}
}
