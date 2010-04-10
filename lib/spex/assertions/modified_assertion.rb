require 'digest/md5'

module Spex

  # With no option, just verifies a change occurs
  class ModifiedAssertion < FileAssertion
    assertion :modified

    def mark!
      if !@options[:added] && !@options[:removed]
        track_checksum!
      end
    end
    
    def before?
      false
    end

    def after(test_case)
      test_case.assert File.exist?(@path), "File does not exist at '#{@path}'"
      if @options[:added]
        raise NotImplementedError, ":added not implemented"
      end
      if @options[:removed]
        raise NotImplementedError, ":removed not implemented"
      end
      if !@options[:added] && !@options[:removed]
        checksum = current_checksum
        test_case.assert_not_equal @before_checksum, checksum, "Checksum did not change"
      end
    end

    # Only supports @:after@
    def describe_should_at(event)
      if @options[:added]
        operation = 'added content to'
      elsif @options[:removed]
        operation = 'removed content from'
      else
        operation = 'modified'
      end
      "have #{operation} file at '#{@path}'"
    end

    private

    def track_checksum!
      @before_checksum = current_checksum
    end

    def current_checksum
      if File.exist?(@path)
        Digest::MD5.hexdigest(File.read(@path))
      else
        nil
      end
    end

    def same_checksum?
      @before_checksum == current_checksum
    end
    
  end
end
