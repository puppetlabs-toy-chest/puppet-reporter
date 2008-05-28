
describe 'report' do
  it 'must have a time'
  it 'must have a node'
  it 'can have 0 or more log entries'
  it 'can have a metrics set'

  describe 'metrics set' do
    it 'can have metrics'

    describe 'metrics' do
      it 'must have a label'
      it 'must have a name'
      it 'must have a list of values'

      describe 'values' do
        it 'should have a name'
        it 'should have a label'
        it 'should have a number'
      end
 
      it 'can be a changes metric'

      describe 'changes metric' do
        it "should have the name 'changes'"
        it "should have the label 'Changes'"

        describe 'values' do
          it 'can be a total value'

          describe 'total value' do
            it "should have a label of 'total'"
            it "should have a name of Total"
          end
        end
      end
  
      it 'can be a resources metric'
  
      describe 'resources metrics' do
        it "should have the name 'resources'"
        it "should have the label 'Resources'"

        describe 'values' do
          it 'can be an out of sync value'

          describe 'out of sync value' do
            it "should have a label of 'out_of_sync'"
            it "should have a name of 'Out of sync'"
          end

          it 'can be an applied value'

          describe 'applied value' do
            it "should have a label of 'applied'"
            it "should have a name of 'Applied'"
          end

          it 'can be a restarted value'

          describe 'restarted value' do
            it "should have a label of 'restarted'"
            it "should have a name of 'Restarted'"
          end

          it 'can be a skipped value'

          describe 'skipped value' do
            it "should have a label of 'skipped'"
            it "should have a name of 'Skipped'"
          end

          it 'can be a scheduled value'

          describe 'scheduled value' do
            it "should have a label of 'scheduled'"
            it "should have a name of 'Scheduled'"
          end

          it 'can be a failed restarts value'

          describe 'failed restarts value' do
            it "should have a label of 'failed_restarts'"
            it "should have a name of 'Failed restarts'"
          end
        
          it 'can be a failed value'

          describe 'failed value' do
            it "should have a label of 'failed'"
            it "should have a name of 'Failed'"
          end
        end
      end
  
      it 'can be a times metric'
  
      describe 'times metrics' do
        it "should have the name 'times'"
        it "should have the label 'Times'"

        describe 'values' do
          it 'can be a total value'

          describe 'total value' do
            it "should have a label of 'total'"
            it "should have a name of 'Total'"
          end

          it 'can be a schedule value'

          describe 'schedule value' do
            it "should have a label of 'schedule'"
            it "should have a name of 'Schedule'"
          end

          it 'can be a file bucket value'

          describe 'file bucket value' do
            it "should have a label of 'filebucket'"
            it "should have a name of 'Filebucket'"
          end

          it 'can be a config retrieval value'

          describe 'config retrieval value' do
            it "should have a label of 'config_retrieval'"
            it "should have a name of 'Config retrieval'"
          end
        end
      end
    end
  end

  describe 'unclear fields' do
    it 'can have records'  # these are empty in all the log files we have
  end
end

describe 'log entries' do
  it 'must have a level'

  describe 'log level' do
    it 'can be in {err, debug, info, notice, warning}'
  end

  it 'must have a message'
  it 'must have a time'

  describe 'unclear fields' do
    it 'can have 0 or more tags'
    it 'may be an objectsource' 
  end
end

describe 'nodes' do
  it 'must have a name'
end

describe 'tags' do
  it 'must have a label'
end
