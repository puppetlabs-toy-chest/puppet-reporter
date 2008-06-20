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
    describe 'when organizing metrics by category' do
      before :each do
        @report = Report.from_yaml(report_yaml)
        @metrics = @report.metrics
      end
      
      it 'should require metrics' do
        lambda { Metric.categorize }.should raise_error(ArgumentError)
      end
      
      it 'should return a hash' do
        Metric.categorize(@metrics).should be_a_kind_of(Hash)
      end
      
      describe 'returned hash' do
        it 'should have a key for each category present in the metrics' do
          Metric.categorize(@metrics).keys.sort.should == @metrics.collect(&:category).sort.uniq
        end
        
        it 'should have a list of values under each category' do
          Metric.categorize(@metrics).values.each {|a| a.should be_a_kind_of(Array) }
        end
        
        it 'should sort values by label' do
          Metric.categorize(@metrics).values.each do |list|
            list.should == list.sort_by(&:label)
          end
        end
                
        it 'should include all metrics somewhere in the categorization' do
          Metric.categorize(@metrics).values.flatten.size.should == @metrics.size
        end
      end
    end
    
    
    describe 'when importing from puppet metrics' do
      before :each do
        @report = Report.generate
        @metrics = @report.details.metrics  # these are the metrics, as thawed from Puppet, to be converted in Metrics
        @metric_items = @metrics.keys.inject([]) {|list, key| list += @metrics[key].values }
      end

      it 'should require puppet metrics' do
        lambda { Metric.from_puppet_metrics }.should raise_error(ArgumentError)
      end
      
      it 'should use the report to create a Metric for every puppet metric' do
        Metric.expects(:create).times(@metric_items.size)
        Metric.from_puppet_metrics(@metrics)          
      end
      
      describe 'and creating a metric' do    
        it 'should set the metric name' do
          @metric_items.each do |metric|
            Metric.expects(:create).with {|args| args[:name] == metric[0] }
          end
          Metric.from_puppet_metrics(@metrics)                    
        end

        it 'should set the metric label' do
          @metric_items.each do |metric|
            Metric.expects(:create).with {|args| args[:label] == metric[1] }
          end
          Metric.from_puppet_metrics(@metrics)                    
        end
        
        it 'should set the metric value' do
          @metric_items.each do |metric|
            Metric.expects(:create).with {|args| args[:value] == metric[2] }
          end
          Metric.from_puppet_metrics(@metrics)                    
        end
        
        it 'should set the metric category' do
          @metrics.keys.each do |category|
            @metrics[category].values.each do |metric|
              Metric.expects(:create).with {|args| args[:category] == category }
            end
          end
          Metric.from_puppet_metrics(@metrics)                    
        end
      end
    end
  end
end
