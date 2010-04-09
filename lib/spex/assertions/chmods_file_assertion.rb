module Spex
  class ChmodsFileAssertion < FileAssertion
    assertion :chmods_file

    def before(test_case)
      if @options[:from]
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal @options[:from].to_s(8), current_mode.to_s(8)
      elsif @options[:changes]
        test_case.assert_not_equal @options[:to].to_s(8), current_mode.to_s(8), "Mode will not be changed; already at mode #{@options[:to].to_s(8)}"
      end
      @before_mode = current_mode
    end

    def before?
      @options[:from] || @options[:changes]
    end

    def after(test_case)
      if @options[:to]
        test_case.assert File.exist?(@path), "File does not exist at #{@path}"
        test_case.assert_equal @options[:to].to_s(8), current_mode.to_s(8)
      elsif @options[:changes]
        test_case.assert_not_equal @before_mode.to_s(8), current_mode.to_s(8), "Mode is still #{@before_mode.to_s(8)}"
      end
    end

    def after?
      @options[:to] || @options[:changes]
    end

    def describe_should_at(event)
      case event
      when :before
        if @options[:from]
          "change mode of file at `#{@path}` from #{@options[:from].to_s(8)}"
        elsif @options[:changes]
          "not have a file at `#{@path}` with a mode of #{@options[:to].to_s(8)}"
        end
      when :after
        if @options[:to]
          "change mode of file at `#{@path}` to #{@options[:to].to_s(8)}"
        elsif @options[:changes]
          "change mode of file at `#{@path}`"          
        end
      else
        super
      end
    end

    def current_mode
      Integer(File.stat(@path).mode.to_s(8)[1..-1])
    end
    
  end
end
