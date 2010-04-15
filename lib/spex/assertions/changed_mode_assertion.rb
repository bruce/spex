module Spex
  class ChangedModeAssertion < FileAssertion
    as :changed_mode, "file mode change"
    option :from, "Mode changed from (octal, eg 0600)"
    option :to, "Mode changed to (octal, eg 0700)"
    
    example "Changed the file mode", "assert '/tmp/foo', :changed_mode => true"
    example "Did not change the file mode", "assert '/tmp/foo', :changed_mode => false"
    example "Changed the file mode from 0666 to 0755", "assert '/tmp/foo', :changed_mode => {:from => 0666, :to => 0755}"
    example "Changed the file mode to 0750", "assert '/tmp/foo', :changed_mode => {:to => 0750}"

    def before
      assert File.exist?(target), "File does not exist at #{target}"
      if options[:from]
        assert_equal options[:from].to_s(8), current_mode.to_s(8)
      elsif options[:to]
        assert_not_equal options[:to].to_s(8), current_mode.to_s(8), "Mode will not be changed; already at mode #{options[:to].to_s(8)}"
      end
      @before_mode = current_mode
    end

    def after
      assert File.exist?(target), "File does not exist at #{target}"
      mode = current_mode.to_s(8)
      if options[:to]
        assert_equal options[:to].to_s(8), mode
      elsif active?
        assert_not_equal @before_mode.to_s(8), mode, "Mode is still #{@before_mode.to_s(8)}"
      elsif !active?
        assert_equal @before_mode.to_s(8), mode, "Mode was changed from #{@before_mode.to_s(8)} to #{mode}"
      end
    end

    def to_s      
      [super, detail].join(' ')
    end

    private

    def detail
      [:from, :to].map do |where|
        if options[where]
          "#{where} %o" % options[where]
        end
      end.compact.join(' ')
    end

    def current_mode
      Integer(File.stat(target).mode.to_s(8)[1..-1])
    end
    
  end
end
