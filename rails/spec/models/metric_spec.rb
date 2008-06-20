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
    
    it 'should have a node' do
      @report = Report.generate
      @metric.report = @report
      @metric.node.should == @report.node
    end
  end
  
  describe 'as a class' do
    before :each do
      @report = Report.generate
      @report_metrics = stub('metrics', :create! => true)
      @report.stubs(:metrics).returns(@report_metrics)
      @metrics = @report.dtl_metrics
      @metric_items = @metrics.keys.inject([]) {|list, key| list += @metrics[key].values }
    end
    
    describe 'when importing from puppet metrics' do
      it 'should require a report' do
        lambda { Metric.from_puppet_metrics }.should raise_error(ArgumentError)
      end
      
      it 'should require puppet metrics' do
        lambda { Metric.from_puppet_metrics(@report) }.should raise_error(ArgumentError)
      end
      
      it 'should use the report to create a Metric for every puppet metric' do
        @report_metrics.expects(:create!).times(@metric_items.size)
        Metric.from_puppet_metrics(@report, @metrics)          
      end
      
      describe 'and creating a metric' do    
        it 'should set the metric name' do
          @metric_items.each do |metric|
            @report_metrics.expects(:create!).with {|args| args[:name] == metric[0] }
          end
          Metric.from_puppet_metrics(@report, @metrics)                    
        end

        it 'should set the metric label' do
          @metric_items.each do |metric|
            @report_metrics.expects(:create!).with {|args| args[:label] == metric[1] }
          end
          Metric.from_puppet_metrics(@report, @metrics)          
        end
        
        it 'should set the metric value' do
          @metric_items.each do |metric|
            @report_metrics.expects(:create!).with {|args| args[:value] == metric[2] }
          end
          Metric.from_puppet_metrics(@report, @metrics)                              
        end
        
        it 'should set the metric category'
      end
    end
  end
end
