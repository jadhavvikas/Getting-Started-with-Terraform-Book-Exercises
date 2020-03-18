host { 'repository': 
  ip => '10.24.45.127', 
}

file { "/var/tmp/testfile":
        ensure => "present",
        owner => "root",
        group => "root",
        mode => "664",
        content => "This is a test file created using puppet.
                    Puppet is really cool",
}