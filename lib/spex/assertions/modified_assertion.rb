require 'digest/md5'

module Spex

  # With no option, just verifies a change occurs
  class ModifiedAssertion < FileAssertion
    as :modified, 'file modification'

    def prepare
      track_checksum!
    end

    def before
      assert File.exist?(target), "File does not exist at '#{target}'"
    end
    
    def after
      assert File.exist?(target), "File does not exist at '#{target}'"
      checksum = current_checksum
      if active?
        assert_not_equal @before_checksum, checksum, "Checksum did not change"
      else
        assert_equal @before_checksum, checksum, "Checksum changed"
      end
    end

    private

    def track_checksum!
      @before_checksum = current_checksum
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
