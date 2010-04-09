module Spex
  class FileAssertion < Assertion

    def initialize(path, options = {})
      @path = path
      @options = options
    end
    
    def kind
      if @options[:directory]
        :directory
      elsif @options[:file]
        :file
      end
    end

    def kind_name
      case kind
      when :file
        'a regular file'
      when :directory
        'a directory'
      else
        'a file'
      end
    end

  end
end
