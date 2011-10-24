require 'spec_helper'

describe Nlp4u::Common::TokenCounter do
  before(:each) do
    @counter = Nlp4u::Common::TokenCounter.new
  end

  it "should process" do
    @counter.process("adventure", %w(ski is fun , I like to ski .))
    @counter.keys.should == ['adventure']
    @counter.freq("adventure", "ski").should == 2
  end
end
