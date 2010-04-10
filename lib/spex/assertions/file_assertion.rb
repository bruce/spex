module Spex
  class FileAssertion < Assertion

    def kind
      if options[:directory]
        :directory
      elsif options[:file]
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
