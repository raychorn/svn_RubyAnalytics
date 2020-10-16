require File.dirname(__FILE__) + "/../lib/methodphitamine.rb"

describe "An It instance" do
  
  before:each do
    @it = Methodphitamine::It.new
  end
  
  it "should queue a single simple method" do
    @it.foo
    queue = @it.methodphitamine_queue
    queue.size.should == 1
    queue.first.size.should == 2
    queue.first.last.should be_nil # No block, ergo nil
  end
  
  it "should store arguments" do
    @it.bar(:qaz, :qwerty)
    @it.methodphitamine_queue.first.should == [[:bar, :qaz, :qwerty], nil]
  end
  
  it "should store a block" do
    @it.map { }
    @it.methodphitamine_queue.first.last.should be_kind_of(Proc)
  end
  
  it "should allow chaining blocks" do
    @it.map {}.inject {}.select {}.sexypants {}
    blocks = @it.methodphitamine_queue.map { |x| x.last }
    blocks.size.should == 4
    blocks.each do |block|
      block.should be_kind_of(Proc)
    end
  end
  
  it "should queue many methods in the right order" do
    @it.a.b.c.d.e.f.g.h.i.j.k.l.m.n.o.p.q.r.s.t.u.v.w.x.y.z
    queue = @it.methodphitamine_queue
    queue.size.should == 26
    queue.map { |x| x.first.first.to_s }.should == ('a'..'z').to_a
  end
  
  it "should respond to to_proc()" do
    @it.should respond_to(:to_proc)
  end
  
  it "should not queue the method respond_to? when given :to_proc as an arg" do
    @it.respond_to? :to_proc
    @it.methodphitamine_queue.should be_empty
  end
  
end
