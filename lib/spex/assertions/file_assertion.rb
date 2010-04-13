module Spex
  class FileAssertion < Assertion

    def kind
      options[:type] ? options[:type].to_sym : :any
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
