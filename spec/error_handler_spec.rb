require "#{ File.dirname(__FILE__) }/spec_helper.rb"

describe subject::ErrorHandler do
  before(:each) { @eh = subject::ErrorHandler.new }

  it "passed all Exceptions to Kernel.raise" do
    proc { @eh.raise Exception.new }.should raise_error(Exception)
  end

  it "calls the closest handle" do
    @eh.handle(ArgumentError) {ArgumentError}
    @eh.handle(StandardError) {StandardError}

    @eh.raise(ArgumentError.new).should == ArgumentError
    @eh.raise(StandardError.new).should == StandardError
    @eh.raise(NoMethodError.new).should == StandardError

    proc { @eh.raise ScriptError.new }.should raise_error(Exception)
  end

end
