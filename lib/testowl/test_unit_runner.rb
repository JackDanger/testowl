# These fix 1.8.7 test/unit results where a DRbUnknown is returned because the testdrb client doesn't have the classes
# in its local namespace.  (See issue #2)
unless RUBY_VERSION =~ /^1\.9/
  # MiniTest is Ruby 1.9, and the classes below only exist in the pre 1.9 test/unit
  require 'test/unit/testresult'
  require 'test/unit/failure'
end
require 'drb'

module Testowl
  class TestUnitRunner

    def run(files)
      puts "Testing #{files.join(", ")}"
      results = nil
      begin
        results = runDrb(files)
      rescue
        puts "Drb not available. Running tests directly instead."
        results = runDirectly(files)
      end
      puts "Done"
      lines = results.split("\n")
      exception_message = lines.detect{|line| line =~ /^Exception encountered/ }
      counts = lines.detect{|line| line =~ /(\d+)\sassertions?,\s(\d+)\sfailures?/ }
      if counts
        file_count, test_count, fail_count = counts.split(',').map(&:to_i)
        timing = lines.detect{|line| line =~ /Finished\sin/}
        timing = timing.sub(/Finished\sin/, '').strip if timing
        return test_count, fail_count, timing
      else
        if exception_message
          raise exception_message
        else
          $stderr.print results
          raise "Problem interpreting output"
        end
      end
    end

    def runDrb(files)
      DRb.start_service("druby://127.0.0.1:0") # this allows Ruby to do some magical stuff so you can pass an output stream over DRb.
      test_server = DRbObject.new_with_uri("druby://127.0.0.1:8988")
      results = StringIO.new
      test_server.run(files, $stderr, results)
      results.string
    end

    def runDirectly(files)
      `ruby #{files.join(' ')}`
    end

  end
end