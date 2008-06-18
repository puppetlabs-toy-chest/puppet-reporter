require File.dirname(__FILE__) + '/../spec_helper'

describe "running the import_yaml_reports.rb script via script/runner" do
  def run_script
    eval File.read(File.join(RAILS_ROOT, 'script', 'import_yaml_reports.rb'))
  end
  
  describe 'when no files are specified on the command-line' do
    before :each do
      Object.send(:remove_const, :ARGV)
      ARGV = []
    end
    
    it 'should fail' do
      lambda { run_script }.should raise_error(ArgumentError)
    end
  end
  
  describe 'when files are specified on the command-line' do
    before :each do
      @filename = '/path/to/some/fictional/claims/file'
      Object.send(:remove_const, :ARGV)
      ARGV = [ @filename ]
    end

    it 'should import Reports from the specified files' do
      Report.expects(:import_from_yaml_files).with(ARGV)
      run_script
    end
  end
end
