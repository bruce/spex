module Spex
  class RemovedCheck < FileCheck
    as :removed, 'file removal'
    option :type, "Type (:file or :directory), optional"
    example "File was removed", "check '/tmp/foo', :removed => true"
    example "File was not removed", "check '/tmp/foo', :removed => false"
    example "Regular file was removed", "check '/tmp/foo', :removed => {:type => 'file'}"
    example "Directory was removed", "check '/tmp/foo', :removed => {:type => 'directory'}"    
    
    def before
      if active?
        assert File.exist?(target), "File does not exist at #{target}"
        check_type
      end
    end

    def after
      if active?
        assert !File.exist?(target), "File still exists at #{target}"
      else
        assert File.exist?(target), "File was removed from #{target}"        
      end
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
