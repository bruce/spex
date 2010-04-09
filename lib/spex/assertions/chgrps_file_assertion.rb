require 'etc'

module Spex
  class ChgrpsFileAssertion < FileAssertion
    assertion :chgrps_file

    def before(test_case)
      if from_groupname
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal from_groupname, current_groupname
      elsif @options[:changes]
        test_case.assert_not_equal to_groupname, current_groupname, "Group will not be changed; already '#{to_groupname}'"
      end
      @before_groupname = current_groupname
    end

    def before?
      from_groupname || @options[:changes]
    end

    def after(test_case)
      if to_groupname
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal to_groupname, current_groupname
      elsif @options[:changes]
        test_case.assert_not_equal @before_groupname, current_groupname, "Group is still '#{@before_groupname}'"
      end
    end

    def after?
      to_groupname || @options[:changes]
    end

    def describe_should_at(event)
      case event
      when :before
        if from_groupname
          "change group of file at `#{@path}` from '#{from_groupname}'"
        elsif @options[:changes]
          "not have a file at `#{@path}` with group '#{to_groupname}'"
        end
      when :after
        if to_groupname
          "have changed group of file at `#{@path}` to '#{to_groupname}'"
        elsif @options[:changes]
          "have changed group of file at `#{@path}`"
        end
      else
        super
      end
    end

    def current_groupname
      normalize(File.stat(@path).gid)
    end

    def from_groupname
      if @options[:from]
        @from_groupname ||= normalize(@options[:from])
      end
    end

    def to_groupname
      if @options[:to]
        @to_groupname ||= normalize(@options[:to])
      end
    end

    def normalize(gid_or_groupname)
      case gid_or_groupname
      when String, Symbol
        gid_or_groupname.to_s
      when Fixnum
        Etc.getgrgid(gid_or_groupname).name
      else
        raise ArgumentError, "Does not appear to be a gid or group name: #{gid_or_groupname}"
      end
    end
    
  end
end
