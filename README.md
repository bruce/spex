Spex
====

A quick and dirty test harness for testing assertions before and after
an executable is run.

Synopsis
--------

Spex is a simple language used to define scenarios that model
the correct behavior of an executable.

The description file consists of exactly one `command` line and any
number of `scenario` definitions; for example, the following file can
be used to verify running `touch /tmp/foo` will create a new file:

    scenario "Creates a file" do
      executing 'touch /tmp/foo' do
        assert '/tmp/foo', :created => true
      end
    end

If this was in `run_touch.rb`, you could run this with spex:

    $ spex run_touch.rb

You'll notice that this should pass the first time and fail on
subsequent invocations -- because the assertion added by `:created => true` fails in the
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

Assertions
----------

See the [wiki](http://wiki.github.com/bruce/spex/supported-assertions)
for the list of supported assertions.

To add an assertion, create a class that inherits from
`Spex::Assertion` and implements all the neccessary methods.  See
`Spex::Assertion` and the currently defined assertions for
examples.

Note: If you put your assertions in `~/.spex/assertions/*.rb`,
they'll automatically be loaded.  If you create any interesting
assertions, add them to the [wiki](http://wiki.github.com/bruce/spex/community-assertions)!

Copyright
---------

Copyright (c) 2010 Bruce Williams. See LICENSE for details.
