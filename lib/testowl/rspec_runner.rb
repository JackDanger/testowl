module Testowl
  class RspecRunner

    def run(files)
      results = `rspec -c #{files.join(" ")}`
      lines = results.split("\n")
      exception_message = lines.detect{|line| line =~ /^Exception encountered/ }
      counts = lines.detect{|line| line =~ /(\d+)\sexamples?,\s(\d+)\sfailures?/ }
      if counts
        test_count, fail_count = counts.split(',').map(&:to_i)
        timing = lines.detect{|line| line =~ /Finished\sin/}
        timing = timing.sub(/Finished\sin/, '').strip if timing
        if fail_count > 0
          puts results
        end
        return test_count, fail_count, timing
      else
        $stderr.print results
        if exception_message
          raise exception_message
        else
          raise "Problem interpreting result. Please check the terminal output."
        end
      end
    end
      
  end
end