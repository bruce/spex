module Spex
  class RemovedAssertion < FileAssertion
    as :removed, 'file removal'
    option :type, "Type (:file or :directory), optional"
    example "File was removed", "assert '/tmp/foo', :removed => true"
    example "File was not removed", "assert '/tmp/foo', :removed => false"
    example "Regular file was removed", "assert '/tmp/foo', :removed => {:type => 'file'}"
    example "Directory was removed", "assert '/tmp/foo', :removed => {:type => 'directory'}"    
    
    def before
      assert File.exist?(target), "File does not exist at #{target}"
      check_type
    end

    def after
      assert !File.exist?(target), "File still exists at #{target}"
    end

    private

    def check_type
      case kind
      when :file
        assert File.file?(target), "File to remove at #{target} is not a regular file"
      when :directory
        assert File.file?(target), "File to remove at #{target} is not a directory"
      end
    end
  end
end
