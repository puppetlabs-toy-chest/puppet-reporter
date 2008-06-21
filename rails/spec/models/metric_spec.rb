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
    
    it 'should get total changes in a time interval' do
      Metric.should respond_to(:total_changes_between)
    end

    describe 'getting total changes in a time interval' do
      before :each do
        Metric.delete_all

        @time = Time.zone.now
        @start_time = @time - 123
        @end_time   = @start_time + 1000

        @metrics = []
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @start_time - 1), :category => 'changes', :label => 'Total')
        10.times do |i|
          @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @start_time + (100 *i)), :category => 'changes', :label => 'Total')
        end
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @end_time), :category => 'changes', :label => 'Total')
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @end_time + 1), :category => 'changes', :label => 'Total')
      end

      it 'should accept start and end times' do
        lambda { Metric.total_changes_between(@start_time, @end_time) }.should_not raise_error(ArgumentError)
      end

      it 'should require an end time' do
        lambda { Metric.total_changes_between(@start_time) }.should raise_error(ArgumentError)
      end

      it 'should require a start time' do
        lambda { Metric.total_changes_between }.should raise_error(ArgumentError)
      end

      it 'should return total changes belonging to reports with timestamps between the two times' do
        total_changes = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_changes_between(@start_time, @end_time).should == total_changes
      end
      
      it 'should return 0 if there are no matching metrics' do
        @metrics[1..-3].each(&:destroy)
        Metric.total_changes_between(@start_time, @end_time).should == 0
      end
      
      it 'should not include non-total change metrics' do
        Metric.generate!(:report => Report.generate!(:timestamp => @start_time + 1), :category => 'changes', :label => 'Bang')
        
        total_changes = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_changes_between(@start_time, @end_time).should == total_changes
      end
      
      it 'should not include non-change metrics' do
        Metric.generate!(:report => Report.generate!(:timestamp => @start_time + 1), :category => 'time', :label => 'Total')
        
        total_changes = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_changes_between(@start_time, @end_time).should == total_changes
      end
      
      it 'should accept options' do
        lambda { Metric.total_changes_between(@start_time, @end_time, :interval => 100) }.should_not raise_error(ArgumentError)
      end

      describe 'when given an interval' do
        it 'should return an array of total change counts for each interval' do
          total_changes = @metrics[1..-3].collect(&:value)
          Metric.total_changes_between(@start_time, @end_time, :interval => 100).should == total_changes
        end
        
        it 'should return 0 for any interval without a total change metric' do
          total_changes = @metrics[1..-3].collect(&:value)
          @metrics[2].destroy
          total_changes[1] = 0
          Metric.total_changes_between(@start_time, @end_time, :interval => 100).should == total_changes
        end
        
        it 'should include a partial interval at the end' do
          total_changes = []
          [1..3, 4..6, 7..9, 10..10].each do |range|
            total_changes.push @metrics[range].collect(&:value).inject(&:+)
          end
          Metric.total_changes_between(@start_time, @end_time, :interval => 300).should == total_changes
        end
      end
    end
    
    it 'should get total failures in a time interval' do
      Metric.should respond_to(:total_failures_between)
    end

    describe 'getting total failures in a time interval' do
      before :each do
        Metric.delete_all

        @time = Time.zone.now
        @start_time = @time - 123
        @end_time   = @start_time + 1000

        @metrics = []
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @start_time - 1), :category => 'resources', :label => 'Failed')
        10.times do |i|
          @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @start_time + (100 *i)), :category => 'resources', :label => 'Failed')
        end
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @end_time), :category => 'resources', :label => 'Failed')
        @metrics.push Metric.generate!(:report => Report.generate!(:timestamp => @end_time + 1), :category => 'resources', :label => 'Failed')
      end

      it 'should accept start and end times' do
        lambda { Metric.total_failures_between(@start_time, @end_time) }.should_not raise_error(ArgumentError)
      end

      it 'should require an end time' do
        lambda { Metric.total_failures_between(@start_time) }.should raise_error(ArgumentError)
      end

      it 'should require a start time' do
        lambda { Metric.total_failures_between }.should raise_error(ArgumentError)
      end

      it 'should return total failures belonging to reports with timestamps between the two times' do
        total_failures = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_failures_between(@start_time, @end_time).should == total_failures
      end
      
      it 'should return 0 if there are no matching metrics' do
        @metrics[1..-3].each(&:destroy)
        Metric.total_failures_between(@start_time, @end_time).should == 0
      end
      
      it 'should not include non-failure resource metrics' do
        Metric.generate!(:report => Report.generate!(:timestamp => @start_time + 1), :category => 'resources', :label => 'Bang')
        
        total_failures = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_failures_between(@start_time, @end_time).should == total_failures
      end
      
      it 'should not include non-resource metrics' do
        Metric.generate!(:report => Report.generate!(:timestamp => @start_time + 1), :category => 'time', :label => 'Failed')
        
        total_failures = @metrics[1..-3].collect(&:value).inject(&:+)
        Metric.total_failures_between(@start_time, @end_time).should == total_failures
      end
      
      it 'should accept options' do
        lambda { Metric.total_failures_between(@start_time, @end_time, :interval => 100) }.should_not raise_error(ArgumentError)
      end

      describe 'when given an interval' do
        it 'should return an array of total failure counts for each interval' do
          total_failures = @metrics[1..-3].collect(&:value)
          Metric.total_failures_between(@start_time, @end_time, :interval => 100).should == total_failures
        end
        
        it 'should return 0 for any interval without a failure metric' do
          total_failures = @metrics[1..-3].collect(&:value)
          @metrics[2].destroy
          total_failures[1] = 0
          Metric.total_failures_between(@start_time, @end_time, :interval => 100).should == total_failures
        end
        
        it 'should include a partial interval at the end' do
          total_failures = []
          [1..3, 4..6, 7..9, 10..10].each do |range|
            total_failures.push @metrics[range].collect(&:value).inject(&:+)
          end
          Metric.total_failures_between(@start_time, @end_time, :interval => 300).should == total_failures
        end
      end
    end
  end
end
