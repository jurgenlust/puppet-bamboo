define bamboo::capability::maven(
	$version = undef
) {
	if ($version) {
		$dist_version = $version
	} else {
		$dist_version = $title
	}
	$build = "apache-maven-${dist_version}"
	$tarball = "${build}-bin.tar.gz"
	$url = "http://apache.cu.be/maven/binaries/${tarball}"
	$path = "/opt/maven-${dist_version}"
	
	exec { "download-maven-${dist_version}":
		command => "/usr/bin/wget -O /tmp/${tarball} ${url}",
		creates => "/tmp/${tarball}",
		timeout => 1200,	
		notify => Exec["extract-maven-${dist_version}"],
	}

	file { "maven-${dist_version}-tarball":
		path => "/tmp/${tarball}", 
		ensure => file,
		require => Exec["download-maven-${dist_version}"],
	}
	
	exec { "extract-maven-${dist_version}":
		command => "/bin/tar -xvzf ${tarball} && mv ${build} ${path}",
		cwd => "/tmp",
		user => 'root',
		creates => $path,
		timeout => 1200,
		refreshonly => true,
		require => File["maven-${dist_version}-tarball"],	
	}
}
