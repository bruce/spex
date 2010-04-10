module Spex
  class CreatedAssertion < FileAssertion
    assertion :created

    def before(test_case)
      test_case.assert !File.exist?(target), "File already exists at #{target}"
    end

    def before_should
      "not find #{kind_name} at `#{target}`"
    end

    def after(test_case)
      test_case.assert File.exist?(target), "File was not created at #{target}"
      case kind
      when :file
        test_case.assert File.file?(target), "File created at #{target} is not a regular file"
      when :directory
        test_case.assert File.file?(target), "File created at #{target} is not a directory"
      end
    end

    def after_should
      "have created #{kind_name} at `#{target}`"
    end
    
  end
end
