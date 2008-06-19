require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Metric do
  before(:each) do
    @metric = Metric.new
  end

  describe 'validations' do
    it 'should not be valid without a report' do
      @metric.should_not be_valid
      @metric.should have(1).errors_on(:report)
    end

    it 'should not error on report if value given' do
      @metric.report = Report.generate
      @metric.valid?
      @metric.errors.should_not be_invalid(:report)
    end

    it 'should not be valid without a label' do
      @metric.should_not be_valid
      @metric.should have(1).errors_on(:label)
    end
    
    it 'should not error on label if value given' do
      @metric.label = 'test'
      @metric.valid?
      @metric.errors.should_not be_invalid(:label)
    end

    it 'should not be valid without a value' do
      @metric.should_not be_valid
      @metric.should have(1).errors_on(:value)
    end
    
    it 'should not error on value if value given' do
      @metric.value = 1
      @metric.valid?
      @metric.errors.should_not be_invalid(:value)
    end
  end
  
  describe 'attributes' do
    it 'can have a label' do
      @metric.label.should be_nil
    end
    
    it 'can have a name' do
      @metric.name.should be_nil
    end
    
    it 'can have a value' do
      @metric.value.should be_nil
    end
  end

  describe 'associations' do
    it 'should have a report' do
      @metric.report.should be_nil
    end
    
    it 'should have a node'
  end
end
