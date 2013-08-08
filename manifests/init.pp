class monit {
	package { 'monit':
		ensure => installed,
	}
	
	service { 'monit':
		ensure => running,
		enable => true,
		hasrestart => true,
		require => Package['monit'],
	}

	file { '/etc/monit/monitrc':
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/monitrc.erb"),
		notify => Service['monit'],
		require => File['/etc/monit'],
	}

	file { '/etc/default/monit':
		mode => 644,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/default.erb"),
		notify => Service['monit'],
		require => Package['monit'],
	}

	file { '/etc/monit/':
		mode => 755,
		owner => root,
		group => root,
		ensure => directory,
		notify => Service['monit'],
		require => Package['monit'],
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
	monit::sshdcheck { "sshdcheck_${fqdn}": }
}

define monit::options ($interval = 180, $mailserver = undef, $email = undef, $http_address = undef, $http_allow = undef, $http_user = undef, $http_password = undef) {
	file { "/etc/monit/conf.d/options_$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/options.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}

define monit::pidcheck ($process_name = undef, $pidfile = undef, $start_prog = undef, $stop_prog = undef) {
	$process_name_real = $process_name ? {
		undef => $name,
		default => $process_name,
	}
	$pidfile_real = $pidfile ? {
		undef => "/var/run/${process_name_real}.pid",
		default => $pidfile,
	}
	$start_prog_real = $start_prog ? {
		undef => "/etc/init.d/${process_name_real} start",
		default => $start_prog,
	}
	$stop_prog_real = $stop_prog ? {
		undef => "/etc/init.d/${process_name_real} stop",
		default => $stop_prog,
	}
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

define monit::clamdcheck ($clamd_port=3310, $clamd_ips=[]) {
	file { "/etc/monit/conf.d/$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/clamd.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}

define monit::sshdcheck ($sshd_port=22, $sshd_ips=[]) {
	file { "/etc/monit/conf.d/$name":
		mode => 600,
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/monit/templates/sshd.erb"),
		notify => Service['monit'],
		require => File['/etc/monit/conf.d'],
	}
}
