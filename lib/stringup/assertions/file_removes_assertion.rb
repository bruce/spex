module Stringup
  class FileRemovesAssertion < FileAssertion
    assertion :removes

    def after(test_case)
      test_case.assert !File.exist?(@path), "File still exists at #{@path}"
    end

    def before(test_case)
      test_case.assert File.exist?(@path), "File does not exist at #{@path}"
      case kind
      when :file
        test_case.assert File.file?(@path), "File to remove at #{@path} is not a regular file"
      when :directory
        test_case.assert File.file?(@path), "File to remove at #{@path} is not a directory"
      end
    end

    def describe_should_at(event)
      case event
      when :after
        "have removed #{kind_name} at `#{@path}`"
      when :before
        "find #{kind_name} at `#{@path}` to remove"
      else
        super
      end
    end
    
  end
end
