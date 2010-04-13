module Spex
  class CreatedAssertion < FileAssertion
    as :created, 'file creation'
    option :type, "Type ('file' or 'directory'), optional"

    def before
      assert !File.exist?(target), "File already exists at #{target}"
    end

    def after
      assert File.exist?(target), "File was not created at #{target}"
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
