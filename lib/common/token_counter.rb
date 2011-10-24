module Nlp4u
  module Common
    # keep track of word count for a given key. Used in Naive Bayes Classifier.
    #
    #   tc = TokenCounter.new
    #   tc.process("adventure", %w(ski is fun , I like to ski .))
    #   tc.freq("adventure", "ski")  => 2
    #
    class TokenCounter
      attr_accessor :main_counter

      def initialize
        self.main_counter = Hash.new
      end

      def process(key, words)
        self.main_counter[key] ||= Hash.new
        counter = self.main_counter[key]

        words.each do |word|
          counter[word] ||= 0
          counter[word] += 1
        end
      end

      # return the frequency of word for a given key
      def freq(key, word)
        main_counter[key][word] || 0
      end

      def keys
        self.main_counter.keys.sort
      end
    end  # TokenCounter
  end
end
