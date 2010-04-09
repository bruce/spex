module Spex
  class CreatesFileAssertion < FileAssertion
    assertion :creates_file

    def before(test_case)
      test_case.assert !File.exist?(@path), "File already exists at #{@path}"
    end

    def after(test_case)
      test_case.assert File.exist?(@path), "File was not created at #{@path}"
      case kind
      when :file
        test_case.assert File.file?(@path), "File created at #{@path} is not a regular file"
      when :directory
        test_case.assert File.file?(@path), "File created at #{@path} is not a directory"
      end
    end

    def describe_should_at(event)
      case event
      when :before
        "not find #{kind_name} at `#{@path}`"
      when :after
        "have created #{kind_name} at `#{@path}`"
      else
        super
      end
    end
    
  end
end
