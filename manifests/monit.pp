class monit {
	package { 'monit':
		ensure => installed,
	}
	
	service { 'monit':
		ensure => running,
		enable => true,
		hasrestart => true,
	}

	file { '/etc/monit/monitrc':
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/monitrc.erb"),
		notify => Service['monit'],
		require => File['/etc/monit'],
	}

	file { '/etc/monit/':
		mode => 755,
		owner => root,
		group => root,
		ensure => directory,
		notify => Service['monit'],
	}
	file { '/etc/monit/conf.d':
		mode => 755,
		owner => root,
		group => root,
		ensure => directory,
		require => File['/etc/monit'],
		notify => Service['monit'],
		recurse => true,
		purge => true,
	}
}

define monit::options ($interval, $mailserver, $email, $http_address, $http_allow, $http_user, $http_password) {
	file { "/etc/monit/conf.d/options_$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/options.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}

define monit::pidcheck ($process_name, $pidfile, $start_prog, $stop_prog) {
	file { "/etc/monit/conf.d/$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/pidcheck.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}

define monit::bindcheck ($bind_ips) {
	file { "/etc/monit/conf.d/$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/bind.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}
