require File.dirname(__FILE__) + '/../spec_helper'

class YourMom
  def at_my_house?() true; end
end

module Spec::Example::ExampleGroupMethods
  def currently(name, &block)
    it("*** CURRENTLY *** #{name}", &block)
  end

  alias_method :she, :it
end

describe YourMom do
  before :each do
    @your_mom = YourMom.new
  end
  
  currently "is at my house" do
    @your_mom.should be_at_my_house
  end
  
  describe "when at my house" do
    before :each do
      @your_mom.stubs(:at_my_house?).returns(true)
    end
    
    she "should take the bus home"
  end
end