require 'helper'

class TestModifiedCheck < Test::Unit::TestCase

  def set_check(options = {})
    @check = Spex::ModifiedCheck.new(@filename, options)
  end

  def non_blank_file!(text = 'test')
    File.open(@filename, 'w') { |f| f.puts text }
  end

  def blank_file!
    File.open(@filename, 'w') { |f| f.puts }
  end
  
  context "Modified Check" do
    setup do
      FakeFS.activate!
      @filename = '/tmp/modified-test'
    end

    teardown do
      FakeFS.deactivate!
    end

    context "instances" do
      context "without options" do
        setup do
          set_check
          blank_file!
        end
        should "pass when modifications happen" do
          check_passes { non_blank_file! }
        end
        should "when modifications don't happen" do
          check_fails
        end
      end
      context "with :added" do
        context "as a string" do
          setup do
            set_check(:added => 'test')
            blank_file!
          end
          context "when the text is added" do
            should "pass" do
              check_passes { non_blank_file! }
            end
          end
          context "when different text is added" do
            should "fail" do
              check_fails { non_blank_file!('other') }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              check_fails
            end
          end
        end
        context "as a regexp" do
          setup do
            set_check(:added => /t.st/)
            blank_file!
          end
          context "when the text is added" do
            should "pass" do
              check_passes { non_blank_file! }
            end
          end
          context "when different text is added" do
            should "fail" do
              check_fails { non_blank_file!('other') }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              check_fails
            end
          end
        end
      end
      context "with :removed" do
        context "as a string" do
          setup do
            set_check(:removed => 'test')
          end
          context "when the text is removed" do
            setup do
              non_blank_file!
            end
            should "pass" do
              check_passes { blank_file! }
            end
          end
          context "when different text is removed" do
            setup do
              non_blank_file!('other')
            end
            should "fail" do
              check_fails { blank_file! }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              check_fails
            end
          end
        end
        context "as a regexp" do
          setup do
            set_check(:removed => /t.st/)
          end
          context "when the text is removed" do
            setup do
              non_blank_file!
            end
            should "pass" do
              check_passes { blank_file! }
            end
          end
          context "when different text is removed" do
            setup do
              non_blank_file!('other')
            end
            should "fail" do
              check_fails { blank_file! }
            end
          end
          context "when modifications don't happen" do
            should "fail when modifications don't happen" do
              check_fails
            end
          end
        end
      end
    end
  end
end
