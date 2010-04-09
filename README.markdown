Stringup
========

A quick and dirty test harness for testing assertions before and after
an executable is run.

Synopsis
--------

Stringup is a simple language used to define scenarios that model
the correct behavior of an executable.

The description file consists of exactly one `command` line and any
number of `scenario` definitions; for example, the following file can
be used to verify running `touch /tmp/foo` will create a new file:

    command 'touch /tmp/foo'

    scenario :new, "Creates a file" do
      assert_creates_file '/tmp/foo'
    end

If this was in `scenarios.rb`, you could run this with stringup:

    $ stringup execute scenarios.rb --scenario new

If you had named the scenario `default`, the `--scenario` option
wouldn't have been necessary, ie:

    scenario :default "Creates a file" do
      assert_creates_file '/tmp/foo'
    end

    $ stringup execute scenarios.rb

You'll notice that this should pass the first time and fail on
subsequent invocations -- because the `assert_creates` fails in the
event a file exists *before* the command is run.

If you want to see what command and scenarios are defined in a file,
use `stringup info`, eg:

    $ stringup info scenarios.rb

Commands with arguments
-----------------------

Let's say you had an executable that reads in a configuration file and
has some type of side-effect.  You'd like to test running the
executable against multiple configuration files checking a scenario,
without having to edit the stringup file every time, changing the path
to the configuration file.

Luckily the command can be provided in `sprintf` style.  Assuming our
executable is named `myexec` and you pass the configuration file to it
via `-c`, the following would work:

    command 'myexec -c %s'

Now, you just pass more options to `stringup execute`:

    $ stringup execute scenarios.rb /path/to/my/configuration.conf

.. and it's just as if you ran:

    $ myexec -c /path/to/my/configuration.conf

Usage help
----------

See the commandline help documentation:

    $ stringup

For more information on specific commands, you'll want to use `help`,
eg:

    $ stringup help execute

Examples
--------

See the `examples/` directory.

Assertions
----------

The list of assertions is very short at this point.

To add an assertion, create a class that inherits from
`Stringup::Assertion` and implements all the neccessary methods.  See
`Stringup::Assertion` and the currently defined assertions for
examples.

Note: If you put your assertions in `~/.stringup/assertions/*.rb`,
they'll automatically be loaded.  If you create any interesting
assertions, make sure you let me know!

### assert_creates_file

Checks to see if a file was created.

You can pass `:file => true` or `:directory => true` to ensure the
file is a regular file or directory.

### assert_removes_file

Checks to see if a file was removed.

You can pass `:file => true` or `:directory => true` to ensure the
file was a regular file or directory before being removed.

Copyright
---------

Copyright (c) 2010 Bruce Williams. See LICENSE for details.
