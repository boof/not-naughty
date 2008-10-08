require "#{ File.dirname(__FILE__) }/spec_helper.rb"

describe subject::Violation do

  before(:each) { @errors = subject::Violation.new }

  it "should add errors in a hash" do
    @errors.add :attribute, 'Message'

    @errors.instance_variable_get(:@errors)[:attribute].
    should include('Message')
  end
  it "should return full messages" do
    @errors.add :attribute, 'Message #{"%s".capitalize}'

    @errors.full_messages.
    should == ['Message Attribute']
  end
  it "should be kind of RuntimeError" do
    @errors.should be_kind_of(RuntimeError)
  end
  it "should have methods delegated" do
    probe = mock 'Probe'
    methods = [:empty?, :clear, :[], :each]

    methods.each { |m| probe.should_receive m }
    @errors.instance_variable_set :@errors, probe

    methods.each { |m| @errors.send m }
  end
  it "should return evaluated errors messages" do
    @errors.add :attribute, 'Message #{"%s".capitalize}'
    @errors.on(:attribute).should == ['Message Attribute']
  end

end
