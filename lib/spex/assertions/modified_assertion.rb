require 'digest/md5'
require 'diff/lcs'
require 'diff/lcs/array'

module Spex

  # With no option, just verifies a change occurs
  class ModifiedAssertion < FileAssertion
    as :modified, 'file modification'
    option :added, "Added content (string or regexp)"
    option :removed, "Removed content (string or regexp)"

    def prepare
      track_checksum!
      track_contents! if options[:added] || options[:removed]
    end

    def before
      assert File.exist?(target), "File does not exist at '#{target}'"
    end
    
    def after
      assert File.exist?(target), "File does not exist at '#{target}'"
      checksum = current_checksum
      if active?
        assert_not_equal @before_checksum, checksum, "Checksum did not change"
        check_added_and_removed if options[:added] || options[:removed]
      else
        assert_equal @before_checksum, checksum, "Checksum changed"
      end
    end

    private

    def check_added_and_removed
      diff = generate_diff
      if options[:added]
        assert_diff_match(diff,
                          '+', options[:added],
                          "Did not add: #{options[:added]}")
      end
      if options[:removed]
        assert_diff_match(diff,
                          '-', options[:removed],
                          "Did not remove: #{options[:removed]}")
      end          
    end

    def assert_diff_match(diff, action, content, message)
      found = diff.any? do |change|
        if change.action == action
          case content
          when String
            change.element.include?(content)
          when Regexp
            change.element.match(content)
          end
        end
      end
      assert found, message
    end

    def generate_diff
      contents = File.readlines(target)
      @before_contents.diff(contents).flatten
    end

    def track_checksum!
      @before_checksum = current_checksum
    end

    def track_contents!
      @before_contents = File.readlines(target)
    end

    def current_checksum
      if File.exist?(target)
        generate_checksum
      else
        nil
      end
    end

    def generate_checksum
      digest = Digest::MD5.new
      File.open(target) do |file|
        while content = file.read(4096)
          digest << content
        end
      end
      digest.hexdigest
    end

    def same_checksum?
      @before_checksum == current_checksum
    end
    
  end
end
