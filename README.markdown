TestOwl
=

![TestOwl](https://github.com/billhorsman/testowl/raw/master/images/testowl.png)

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

It uses [growlnotifiy](http://growl.info/extras.php) to send messages to Growl. If you don't have it installed then it will only write a message to your terminal. To get the full benefit of TestOwl you should definitely install growlnotify.

Bundler
==

To install using Bundler:

    group :test do
      gem 'testowl', :git => "git@github.com:billhorsman/testowl.git"
    end

RSpec
==

TestOwl looks for <code>spec/spec_helper.rb</code> and if it finds it then it uses RSpec.

Test Unit
==

TestOwl looks for <code>test/test_helper.rb</code> and if it finds it then it uses Test Unit. Actually, it looks for <code>spec/spec_helper.rb</code> first and only checks for Test Unit if it can't find RSpec.

Spork
==

[Spork](https://github.com/timcharper/spork) is a testing framework for RSpec and Cucumber that forks before each run to ensure a clean testing state. By preloading the Rails environment it speeds up the launch time to run tests. This is especially significant when running single, small tests.

If you are running Spork then it will use it (assuming it is on port 8988) but if it gets no response on that port then it will just run the tests directly.

Spork doesn't support Test Unit out of the box, but it does if you include the [spork-testunit](https://github.com/timcharper/spork-testunit) gem. This is what your Gemfile might look like

    group :test do
      gem 'spork', "~> 0.9.0.rc"
      gem 'spork-testunit', :git => 'git://github.com/timcharper/spork-testunit.git'
      gem 'testowl', :git => "git@github.com:billhorsman/testowl.git"
    end

To get it running you just:

    $ bundle exec spork
    Using TestUnit
    Preloading Rails environment
    Loading Spork.prefork block...
    Spork is ready and listening on 8988!

Todo
==

* Make Drb port configurable
* DSL to define relationship between changed files and tests to run.
* Add some more rules for relationships (with or without DSL)

Credits
==

Copyright (c) 2011 [Bill Horsman](http://bill.logicalcobwebs.com), released under the MIT license.