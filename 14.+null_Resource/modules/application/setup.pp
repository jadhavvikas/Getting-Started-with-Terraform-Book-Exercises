file { "/var/tmp/testfile":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => "664",
        content => "This is a test file created using puppet.
                    Puppet is really cool",
}
file { "/var/tmp/testfile2":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => "664",
        content => "This is a test file created using puppet.
                    Puppet is really cool",
}
