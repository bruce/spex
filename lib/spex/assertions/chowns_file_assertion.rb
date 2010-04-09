require 'etc'

module Spex
  class ChownsFileAssertion < FileAssertion
    assertion :chowns_file

    def before(test_case)
      if from_username
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal from_username, current_username
      elsif @options[:changes]
        test_case.assert_not_equal to_username, current_username, "Owner will not be changed; already '#{to_username}'"
      end
      @before_username = current_username
    end

    def before?
      from_username || @options[:changes]
    end

    def after(test_case)
      if to_username
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal to_username, current_username
      elsif @options[:changes]
        test_case.assert_not_equal @before_username, current_username, "Owner is still '#{@before_username}'"
      end
    end

    def after?
      to_username || @options[:changes]
    end

    def describe_should_at(event)
      case event
      when :before
        if from_username
          "change owner of file at `#{@path}` from '#{from_username}'"
        elsif @options[:changes]
          "not have a file at `#{@path}` with owner '#{to_username}'"
        end
      when :after
        if to_username
          "have changed owner of file at `#{@path}` to '#{to_username}'"
        elsif @options[:changes]
          "have changed owner of file at `#{@path}`"
        end
      else
        super
      end
    end

    def current_username
      normalize(File.stat(@path).uid)
    end

    def from_username
      if @options[:from]
        @from_username ||= normalize(@options[:from])
      end
    end

    def to_username
      if @options[:to]
        @to_username ||= normalize(@options[:to])
      end
    end

    def normalize(uid_or_username)
      case uid_or_username
      when String, Symbol
        uid_or_username.to_s
      when Fixnum
        Etc.getpwuid(uid_or_username).name
      else
        raise ArgumentError, "Does not appear to be a uid or username: #{uid_or_username}"
      end
    end
    
  end
end
