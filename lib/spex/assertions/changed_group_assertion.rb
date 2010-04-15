require 'etc'

module Spex
  class ChangedGroupAssertion < FileAssertion
    as :changed_group, 'file group change'
    option :to, "To group name or gid"
    option :from, "From group name or gid"
    
    example "Changed the file group", "assert '/tmp/foo', :changed_group => true"
    example "Did not change the file group", "assert '/tmp/foo', :changed_group => false"
    example "Changed the file group from 'wheel' to 'www-users'", "assert '/tmp/foo', :changed_group => {:from => 'wheel', :to => 'www-users'}"
    example "Changed the file group from gid 210 to gid 288", "assert '/tmp/foo', :changed_group => {:from => 210, :to => 288}"
    example "Changed the file group to 'users'", "assert '/tmp/foo', :changed_group => {:to => 'users'}"
    example "Changed the file group to gid 203", "assert '/tmp/foo', :changed_group => {:to => 203}"
    
    def before
      assert File.exist?(target), "File does not exist at #{target}"
      if from_groupname
        assert_equal from_groupname, current_groupname
      elsif active?
        assert_not_equal to_groupname, current_groupname, "Group will not be changed; already '#{to_groupname}'"
      end
      @before_groupname = current_groupname
    end

    def after
      assert File.exist?(target), "File does not exist at #{target}"
      current = current_groupname
      if to_groupname
        assert_equal to_groupname, current
      elsif active?
        assert_not_equal @before_groupname, current, "Group is still '#{@before_groupname}'"
      elsif !active?
        assert_equal @before_groupname, current, "Group changed from '#{@before_groupname}' to '#{current}'"
      end
    end

    private

    def current_groupname
      normalize(File.stat(target).gid)
    end

    def from_groupname
      if options[:from]
        @from_groupname ||= normalize(options[:from])
      end
    end

    def to_groupname
      if options[:to]
        @to_groupname ||= normalize(options[:to])
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
