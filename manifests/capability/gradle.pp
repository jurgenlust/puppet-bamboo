define bamboo::capability::gradle(
	$version = undef
) {
	if ($version) {
		$dist_version = $version
	} else {
		$dist_version = $title
	}
	$build = "gradle-${dist_version}"
	$archive = "${build}-bin.zip"
	$url = "http://services.gradle.org/distributions/${archive}"
	$path = "/opt/gradle-${dist_version}"
	
	if ! defined(Package["unzip"]) {
		package{ 'unzip':
			ensure => present,
		}
	}

	exec { "download-gradle-${dist_version}":
		command => "/usr/bin/wget -O /tmp/${archive} ${url}",
		creates => "/tmp/${archive}",
		timeout => 1200,
		notify => Exec["extract-gradle-${dist_version}"],	
	}

	file { "gradle-archive-${dist_version}":
		path => "/tmp/${archive}", 
		ensure => file,
		require => Exec["download-gradle-${dist_version}"],
	}
	
	exec { "extract-gradle-${dist_version}":
		command => "/usr/bin/unzip ${archive} && mv ${build} ${path}",
		cwd => "/tmp",
		user => 'root',
		creates => $path,
		timeout => 1200,
		refreshonly => true,
		require => [
			File["gradle-archive-${dist_version}"],
			Package['unzip']
		]
	}
}
