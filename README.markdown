TestOwl
=

Narrow Minded TestUnit/RSpec, Watchr and Growl Integration for Continuous Testing. TestOwl assumes you are running Rails and makes some guesses about what tests depend on what files. For instance, if you change model Foo then it looks for foo_test.rb and foos_controller_test.rb.

At the very least, it will run each test every time you save it.

Usage 
==

From Rails root:

    testowl

Er, that's it. If you're using [bundler](http://gembundler.com/) then you should probably run:

    bundle exec testowl

Dependencies
==

It uses Watchr to monitor which files are changed. 

It uses [growlnotifiy](http://growl.info/extras.php) to send messages to Growl.

Test Unit
==

It assumes Test Unit at the moment, although it wouldn't take much to support RSpec too.

Spork
==

[Spork](https://github.com/timcharper/spork) is a testing framework for RSpec and Cucumber that forks before each run to ensure a clean testing state. By preloading the Rails environment it speeds up the launch time to run tests. This is especially significant when running single, small tests.

If you are running Spork then it will use it (assuming it is on port 8988) but if it gets no response on that port then it will just run the tests directly.

Todo
==

* Support Rspec
* Make Drb port configurable
* Make DSL to define relationship between changed files and tests to run.
* Add some more rules for relationships
* Make it more resilient to growlnotify not being installed

Credits
==

Copyright (c) 2011 (http://bill.logicalcobwebs.com)[Bill Horsman], released under the MIT license.