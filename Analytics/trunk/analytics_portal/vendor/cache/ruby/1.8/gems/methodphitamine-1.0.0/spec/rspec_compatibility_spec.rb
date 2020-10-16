require File.dirname(__FILE__) + "/../lib/methodphitamine.rb"

describe "The Methodphitamine's RSpec compatibility" do
  
  # Surprisingly, RSpec's it() method isn't even defined within the context
  # of each expectation block. Man, that's some crazy voodoo.
  
  it "should make available the it and its methods" do
    should respond_to(:it)
    should respond_to(:its)
    method(:it).should == method(:its) # Ensure it's not RSpec's it() method
    lambda do
      it.should be_kind_of(Methodphitamine::It)
    end.should_not raise_error
  end
  
  it "should work with RSpec's assertion methods" do
    [1,2,3].each &it.should(be_kind_of(Fixnum))
  end
end