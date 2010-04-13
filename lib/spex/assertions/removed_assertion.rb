module Spex
  class RemovesFileAssertion < FileAssertion
    as :removes, 'file removal'
    option :mode, "Mode, in octal (eg: 0600), optional"
    option :type, "Type (:file or :directory), optional"

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
