module Spex
  class CreatedCheck < FileCheck
    as :created, 'file creation'
    option :type, "Type ('file' or 'directory'), optional"
    example "File was created", "check '/tmp/foo', :created => true"
    example "File was not created", "check '/tmp/foo', :created => false"
    example "Regular file was created", "check '/tmp/foo', :created => {:type => 'file'}"
    example "Directory was created", "check '/tmp/foo', :created => {:type => 'directory'}"    

    def before
      if active?
        assert !File.exist?(target), "File already exists at #{target}"
      end
    end

    def after
      if active?
        assert File.exist?(target), "File was not created at #{target}"
      else
        assert !File.exist?(target), "File was created at #{target}"        
      end
      check_type
    end

    private

    def check_type
      case kind
      when :file
        assert File.file?(target), "File created at #{target} is not a regular file"
      when :directory
        assert File.directory?(target), "File created at #{target} is not a directory"
      end
    end
  end
end
