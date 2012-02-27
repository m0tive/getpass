Ruby getpass
============

Get passwords on the command line and see `*`s.

Example
-------

    require 'getpass'
    include Getpass
    
    print 'Username: '
    username = gets.chomp
    print 'Password: '
    password = getpass
    
    # or
    
    password = getpass :prompt => 'Password: '

Author
------

* [Peter Dodds](http://pddds.com)

Licence
-------

MIT License. See the included LICENCE file.
