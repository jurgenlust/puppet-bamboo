define bamboo::capability::ant(
	$version = undef
) {
	if ($version) {
		$dist_version = $version
	} else {
		$dist_version = $title
	}
	$build = "apache-ant-${dist_version}"
	$tarball = "${build}-bin.tar.gz"
	$url = "http://apache.cu.be/ant/binaries/${tarball}"
	$path = "/opt/ant-${dist_version}"
	
	exec { "download-ant-${dist_version}":
		command => "/usr/bin/wget -O /tmp/${tarball} ${url}",
		creates => "/tmp/${tarball}",
		timeout => 1200,
		notify => Exec["extract-ant-${dist_version}"],	
	}

	file { "ant-${dist_version}-tarball":
		path => "/tmp/${tarball}", 
		ensure => file,
		require => Exec["download-ant-${dist_version}"],
	}
	
	exec { "extract-ant-${dist_version}":
		command => "/bin/tar -xvzf ${tarball} && mv ${build} ${path}",
		cwd => "/tmp",
		user => 'root',
		creates => $path,
		timeout => 1200,
		refreshonly => true,
		require => File["ant-${dist_version}-tarball"],	
	}
}
