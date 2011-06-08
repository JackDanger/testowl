module Testowl
  class Monitor

    attr_reader :test_dir

    def initialize()
      @runner = TestUnitRunner.new
      @test_dir = "test"
    end

    def run
      script = Watchr::Script.new
      # Watch the scripts themselves
      script.watch("#{test_dir}/.*/*_test\.rb") do |match|
        puts "Detected change in #{match[0]}"
        fire [match[0]], "has been updated"
      end
      # Watch models
      script.watch("app/models/(.*)\.rb") do |match|
        puts "Detected change in #{match[0]}"
        tests = []
        model = match[1]
        tests += tests_for_model(model)
        fire tests, "triggered by #{match[0]}"
      end
      puts "Monitoring files..."
      Watchr::Controller.new(script, Watchr.handler.new).run
    end

    def fire(files, reason)
      return if files.nil? || files.size == 0
      # We don't want to do no performance testing
      files = files.map{|file| file =~ /^test\/performance\// ? nil : file }.compact
      puts "Running #{files.join(", ")}"
      begin
        test_count, fail_count, timing = @runner.run(files)
        if test_count == 0
          Growl.grr "Empty Test", "No tests run", :error, files, reason
        elsif fail_count > 0
          Growl.grr "Fail", "#{fail_count} out of #{test_count} test#{'s' if test_count > 1} failed in #{timing} :(", :failed, files, reason
        else
          Growl.grr "Pass", "All #{test_count} example#{'s' if test_count > 1} passed in #{timing} :)", :success, files, reason
        end
      rescue => exc
        Growl.grr "Exception", exc.message, :error, files, reason
      end
    end

    def tests_for_model(model)
      tests = []
      tests += Dir["#{test_dir}/**/#{model.pluralize}_controller_test.rb"]
      tests += Dir["#{test_dir}/**/#{model}_test.rb"]
      class_name = model.classify
      count = 0
      `grep #{class_name} -R app/controllers/* | grep '# Dependencies'`.lines.each do |line|
        tests += Dir[line.split(':').first.sub(/^app/, 'test').sub(/\.rb$/, '_test.rb')]
        count += 1
      end
      puts "Found 1 dependency" if count == 1
      puts "Found #{count} dependencies" if count > 1
      tests
    end

  end
end