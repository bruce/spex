Spex
====

A quick and dirty harness for running system state checks before and after
an executable is run.

It can be used:

* When developing an executable/configuration, to check real-world
  results.
* In production, to ensure the system is in a known state before an
  executable is run.
* In production, to provide independent logging/reporting of
  executable status.

Synopsis
--------

Spex is a simple language used to define scenarios that model
the correct behavior of an executable.

The description file consists of exactly one `command` line and any
number of `scenario` definitions; for example, the following file can
be used to verify running `touch /tmp/foo` will create a new file:

    scenario "Creates a file" do
      executing 'touch /tmp/foo' do
        check '/tmp/foo', :created => true
      end
    end

If this was in `run_touch.rb`, you could run this with spex:

    $ spex run_touch.rb

You'll notice that this should pass the first time and fail on
subsequent invocations -- because the check added by `:created => true` fails in the
event a file exists *before* the command is run.

If you want to see what command and scenarios are defined in a file,
use `spex info`, eg:

    $ spex --describe run_touch.rb

Usage help
----------

See the commandline help documentation:

    $ spex --help

Examples
--------

See the `examples/` directory.

Checks
------

You can see the checks that are available with the following command:

    $ spex --checks

To add an check, create a class that inherits from
`Spex::Check` and implements all the neccessary methods.  See
`Spex::Check` and the currently defined checks for
examples.

Note: If you put your checks in `~/.spex/checks/*.rb`,
they'll automatically be loaded.  If you create any interesting
checks, add them to the
[wiki](http://wiki.github.com/bruce/spex/community-checks)!

Other Resources
---------------

For more information, see the
[wiki](http://wiki.github.com/bruce/spex).

You can file bugs and features using the [issue tracker](http://github.com/bruce/spex/issues).

Copyright
---------

Copyright (c) 2010 Bruce Williams. See LICENSE for details.
