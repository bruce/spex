require 'etc'

module Spex
  class ChangedOwnerAssertion < FileAssertion
    as :changed_owner, 'file owner change'
    option :from, "From username or uid"
    option :to, "To username or uid"
    
    def before
      assert File.exist?(target), "File does not exist at #{target}"
      if from_username
        assert_equal from_username, current_username, "File is not owned by '#{from_username}'"
      elsif to_username
        assert_not_equal to_username, current_username, "Owner will not be changed; already '#{to_username}'"
      end
      @before_username = current_username
    end

    def after
      current = current_username
      if to_username
        assert File.exist?(target), "File does not exist at #{target}"
        assert_equal to_username, current
      elsif active?
        assert_not_equal @before_username, current, "Owner is still '#{@before_username}'"
      elsif !active?
        assert_equal @before_username, current, "Owner was changed from '#{@before_username}' to '#{current}'"
      end
    end

    def to_s
      [super, detail].join(' ')
    end

    private

    def detail
      [:from, :to].map do |where|
        if options[where]
          "#{where} %s" % normalize(options[where])
        end
      end.compact.join(' ')
    end
    
    def current_username
      normalize(File.stat(target).uid)
    end

    def from_username
      if options[:from]
        @from_username ||= normalize(options[:from])
      end
    end

    def to_username
      if options[:to]
        @to_username ||= normalize(options[:to])
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
