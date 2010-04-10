require 'helper'

class TestAssertion < Test::Unit::TestCase
  context "Assertion" do
    setup do
      @klass = Class.new(Spex::Assertion)
    end

    context "instances" do
      should "raise an exception if instantiated with an unknown option" do
        assert_raises Spex::Assertion::UnknownOptionError do
          @klass.new('/tmp/foo', :unknown => 'option')
        end
      end
    end

    context "classes" do
      context "after being registered" do
        setup do
          @klass.assertion :something
        end
        
        should "be added to the list of assertions" do
          assert_equal @klass, Spex::Assertion[:something]
        end    
      end
      
      context "setting an option" do
        setup do
          @klass.option :to, 'A desc'
        end
        
        should "add one to the mapping" do
          assert_kind_of Hash, @klass.options
          assert_equal 1, @klass.options.size
        end
        
        context "and the option" do
          setup do
            @option = @klass.options[:to]
          end
          
          should "be of the correct class" do
            assert_kind_of Spex::Assertion::Option, @option
          end
          
          should "have a name" do
            assert_equal :to, @option.name
          end
          
          should "have a description if given" do
            assert_equal 'A desc', @option.description
          end
        end
      end
    end
  end
end
