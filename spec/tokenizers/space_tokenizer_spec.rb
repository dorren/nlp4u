require 'spec_helper'

describe Nlp4u::Tokenizers::SpaceTokenizer do
  before(:each) do
    @zer = Nlp4u::Tokenizers::SpaceTokenizer
  end

  it "should tokenize normal text" do
    arr = @zer.tokenize %(ski is fun, I like to ski.)
    arr.should == %w(ski is fun i like to ski)
  end

  it "should tokenize text on slash" do
    arr = @zer.tokenize %(snow/ski are winter sports.)
    arr.should ==  %w(snow/ski are winter sports)
  end

  it "should tokenzie on dash" do
    arr = @zer.tokenize %(happy-birthday song is copyrighted.)
    arr.should == %w(happy-birthday song is copyrighted)
  end

  it "should tokenize on quotes" do
    arr = @zer.tokenize %(He said, "Good morning. 'boss'")
    arr.should == %w(he said good morning boss)
  end
end
