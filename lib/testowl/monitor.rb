module Testowl
  class Monitor

    attr_reader :test_dir, :test_suffix

    def initialize()
      if File.exist?("spec/spec_helper.rb")
        @runner = RspecRunner.new
        @test_dir = "spec"
        @test_suffix = "spec"
      elsif File.exist?("test/test_helper.rb")
        @runner = TestUnitRunner.new
        @test_dir = "test"
        @test_suffix = "test"
      else
        raise "Can't find either spec_helper.rb or test_helper.rb and this owl is confused."
      end
    end

    def run
      script = Watchr::Script.new
      # Watch the scripts themselves
      script.watch("#{test_dir}/.*/*_#{test_suffix}\.rb") do |match|
        puts "Detected change in #{match[0]}"
        run_test(match[0])
      end
      # Watch models
      script.watch("app/models/(.*)\.rb") do |match|
        puts "Detected change in #{match[0]}"
        run_model(match[1], "triggered by #{match[0]}")
      end
      puts "Monitoring files..."
      Watchr::Controller.new(script, Watchr.handler.new).run
    end

    def run_test(file)
      tester = Tester.new(@runner, "has been updated")
      tester.add file
      tester.run
    end

    def run_model(model_name, reason)
      tester = Tester.new(@runner, reason)
      tester.add Dir["#{test_dir}/**/#{model_name}_#{test_suffix}.rb"]
      tester.add Dir["#{test_dir}/**/#{model_name.pluralize}_controller_#{test_suffix}.rb"]
      tester.run
    end

    def tests_for_model(model)
      tests = []
      tests += Dir["#{test_dir}/**/#{model.pluralize}_controller_#{test_suffix}.rb"]
      tests += Dir["#{test_dir}/**/#{model}_#{test_suffix}.rb"]
      class_name = model.classify
      count = 0
      `grep #{class_name} -R app/controllers/* | grep '# Dependencies'`.lines.each do |line|
        tests += Dir[line.split(':').first.sub(/^app/, test_suffix).sub(/\.rb$/, "_#{test_suffix}.rb")]
        count += 1
      end
      puts "Found 1 dependency" if count == 1
      puts "Found #{count} dependencies" if count > 1
      tests
    end

  end
end