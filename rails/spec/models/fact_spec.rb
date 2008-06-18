require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Fact do
  before(:each) do
    @fact = Fact.new
  end

  describe "when validating" do
    it "should be valid" do
      @fact.should be_valid
    end    
  end
  
  describe 'associations' do
    it 'should have a node' do
      @fact.node.should be_nil
    end  
  end
  
  describe 'attributes' do
    it 'should have values' do
      @fact.values.should be_nil
    end
    
    it 'should have a timestamp' do
      @fact.timestamp.should be_nil
    end
  end

  describe 'values' do
    before :each do
      @fact = Fact.spawn
    end
    
    it 'should be able to store a hash' do
      @fact.values = { :foo => 'bar' }
      @fact.save
      @fact.values.should == { :foo => 'bar' }
    end
    
    it 'should keep the hash of values data' do
      @fact.values = { :foo => 'bar' }
      @fact.save
      @fact.reload.values.should == { :foo => 'bar' }
    end
  end
  
  describe 'when saving' do
    it 'should default the timestamp to now' do
      @time = Time.now
      Time.stubs(:now).returns(@time)
      @fact.save
      @fact.reload.timestamp.to_i.should == @time.to_i
    end
    
    it 'should default the values to an empty hash' do
      @fact.save
      @fact.reload.values.should == {}
    end
  end
  
  class Puppet
    class Node
      class Facts
      end
    end
  end
  
  describe 'as a class' do
    describe 'refreshing facts for a node' do
      before :each do
        @node = Node.new(:name => 'foo')
        @hash = { :operatingsystem => 'Darwin', 'processor' => '386'}
        Puppet::Node::Facts.stubs(:terminus_class=)
        Puppet::Node::Facts.stubs(:find).returns(@hash)
      end
      
      it 'should require a node' do
        lambda { Fact.refresh_for_node }.should raise_error(ArgumentError)
      end
      
      it 'should ensure that the YAML fact terminus is in use' do
        Puppet::Node::Facts.expects(:terminus_class=).with(:yaml)
        Fact.refresh_for_node(@node)
      end
      
      it 'should ask Puppet for Facts for the node' do
        Puppet::Node::Facts.expects(:find).with(@node.name).returns(@hash)
        Fact.refresh_for_node(@node)        
      end
      
      describe 'when there is an error asking Puppet for Facts' do
        it 'should raise an error' do
          Puppet::Node::Facts.expects(:find).raises(Exception)
          lambda { Fact.refresh_for_node(@node) }.should raise_error          
        end
      end
      
      describe 'when there are no Facts found' do
        it 'should raise an error' do
          Puppet::Node::Facts.expects(:find).returns(nil)
          lambda { Fact.refresh_for_node(@node) }.should raise_error                    
        end
      end
      
      describe 'when Facts are found' do
        before :each do
          Puppet::Node::Facts.stubs(:find).returns(@hash)
        end
        
        it 'should store them as a new Fact instance' do
          Fact.expects(:new).with {|args| args[:values] == @hash }
          Fact.refresh_for_node(@node)
        end
                
        it 'should return the new Fact instance' do
          Fact.refresh_for_node(@node).values.should == @hash
        end
      end
    end
    
    describe 'important_facts' do
      it 'should return an ordered list of important facts' do
        Fact.important_facts.should respond_to(:size)
      end
      
      it 'should have a label for each important fact' do
        Fact.important_facts.each do |fact|
          fact.has_key?(:label).should be_true
        end
      end
      
      it 'should have a key for each important fact' do
        Fact.important_facts.each do |fact|
          fact.has_key?(:key).should be_true
        end
      end
    end
  end
end
