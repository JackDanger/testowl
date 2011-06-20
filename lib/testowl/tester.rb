module Testowl
  class Tester

    def initialize(runner, reason)
      @runner = runner
      @reason = reason
      @files_list = []
    end

    def add(files)
      @files_list << [files].flatten
    end

    def run
      test_count = 0
      fail_count = 0
      files_run = []
      begin
        @files_list.each do |files|
          result = @runner.run(files)
          files_run += files
          test_count += result[0]
          fail_count += result[1]
          break if fail_count > 0
        end
        if test_count == 0
          Growl.grr "Empty Test", "No tests run", :error, files_run, @reason
          return false
        elsif fail_count > 0
          Growl.grr "Fail", "#{fail_count} out of #{test_count} test#{'s' if test_count > 1} failed :(", :failed, files_run, @reason
          return false
        else
          Growl.grr "Pass", "All #{test_count} example#{'s' if test_count > 1} passed :)", :success, files_run, @reason
          return true
        end
      rescue => exc
        Growl.grr "Exception", exc.message, :error, files_run, @reason
      end
    end

  end
end