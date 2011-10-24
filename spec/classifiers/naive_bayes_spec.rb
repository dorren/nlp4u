require 'spec_helper'

describe Nlp4u::Classifiers::NaiveBayes do
  before(:each) do
    @nb = Nlp4u::Classifiers::NaiveBayes.new
    @tokenizer = Nlp4u::Tokenizers::SpaceTokenizer
  end

  describe "train" do
    before(:each) do
      @nb.train("adventure", %(ski is fun, I like to ski.))
    end

    it "should count category and default" do
      @nb.counter.keys.sort.should == ["adventure"]
    end
  end

  describe "classify" do
    before(:each) do
      @nb.train("adventure", %(ski is fun, I like to ski.))
      @nb.train("adventure", %(ski is fun, snowboarding is fun and exciting too.))
      @nb.train("adventure", %(swimming is what you do in the summer for fun.))
      @nb.train("adventure", %(zzz))
      @nb.train("other", %(some random text, nothing interesting or fun.))
      @nb.train("other", %(zzz sleeping))
      @nb.train("other", %(bored blah blah))
      @nb.train("other", %(etc text string characters paragraph))
    end

    it "should show word_prob" do
      p1 = @nb.word_prob("adventure", "ski")
      p2 = @nb.word_prob("other", "ski")
      p1.should > p2

      p1 = @nb.word_prob("adventure", "random")
      p2 = @nb.word_prob("other", "random")
      p1.should < p2
    end

    it "should classify" do
      arr = @nb.classify("what to do for fun in summer")
      arr.first.first.should == 'adventure'
      arr = @nb.classify("random fun anytime")
      arr.first.first.should == 'other'
      arr = @nb.classify("sleeping zzz drinking walking running")
      arr.first.first.should == 'other'
    end

  end

  describe "edgy_words" do
    it "should return edgy words" do
      key = 'a'
      hash = (1..30).to_a.inject({}){|h, i|
        h[key] = 1.0 * i / 31
        key = key.next
        h
      }

      @nb.edgy_words(hash).keys.size.should == 15
    end
  end
end
