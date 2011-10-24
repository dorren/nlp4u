module Nlp4u
  module Classifiers
    #   nb = NaiveBayes.new
    #
    #   nb.train("business", "Steve Jobs, CEO of Apple Inc, passed away on Oct 5th, 2011")
    #   nb.train("politics", "Obama is the current president")
    #
    #   nb.classify("I use Apple's macbook pro")  =>
    #     [["business", 0.76],
    #      ["politics', 0.02]
    #     ]
    #
    class NaiveBayes
      attr_reader :counter, # word/token counter
                  :doc_counter # document counter for each category
      attr_accessor :tokenizer

      def initialize
        @counter = Common::TokenCounter.new
        @doc_counter = Hash.new
        @tokenizer = Tokenizers::SpaceTokenizer
      end

      # train the Naive Bayes Classififer
      def train(categories, text)
        words = @tokenizer.tokenize(text)

        [*categories].each do |category|
          self.counter.process(category, words)
          @doc_counter[category] ||= 0
          @doc_counter[category]  += 1
        end
      end

      # return freq of word in a give category, or sum in categories.
      def word_freq(categories, word)
        [*categories].inject(0){|sum, category|
          sum += self.counter.freq(category, word)
        }
      end

      # return number of documents for given category or categories
      def doc_size(categories)
        [*categories].inject(0){|sum, category|
          sum += @doc_counter[category] || 0
        }
      end

      # calculate the likelihood of word belongs to a given category
      #
      # based on http://www.paulgraham.com/spam.html
      def word_prob(category, word)
        cat_freq = word_freq(category, word)
        non_cat_freq = word_freq(counter.keys, word) - cat_freq
        cat_docs = doc_size(category)
        non_cat_docs = doc_size(doc_counter.keys) - cat_docs

        cat_prob     = [1.0 *     cat_freq / cat_docs,     1.0].min
        non_cat_prob = [1.0 * non_cat_freq / non_cat_docs, 1.0].min

        if cat_prob == 0.0
          cond_prob = 0.4
        else
          cond_prob = 1.0 * cat_prob / (cat_prob + non_cat_prob)
        end

        # STDOUT.puts "#{category}-#{word},  cat #{cat_prob},  non_cat #{non_cat_prob},  cond_p #{cond_prob}"

        cond_prob = [[cond_prob, 0.99].min, 0.01].max
      end

      def classify(text)
        words = @tokenizer.tokenize(text).uniq

        arr = self.counter.keys.collect do |category|
          probs_hash = words.inject({}){|h, x| h[x] = word_prob(category, x); h}
          probs_hash = edgy_words(probs_hash)
          probs = probs_hash.values

          # see http://www.paulgraham.com/naivebayes.html
          #                    abc
          #   score = ---------------------
          #           abc + (1-a)(1-b)(1-c)
          prod = probs.inject(1.0){|all, x| all *= x}
          neg = probs.inject(1.0){|all, x| all *= (1.0 - x)}
          score = 1.0 * prod / (prod + neg)
          [category, score]
        end

        arr.sort{|x, y| y[1] <=> x[1]}
      end


      # given a hash with key is word, and value is probability (0 to 1),
      # return top 15 words with probability that are close to 0 or 1, in other words,
      # most distant from middle (0.5).
      def edgy_words(hash)
        return hash if hash.keys.size <= 15

        h = hash.dup
        h.each do |word, prob|
          h[word] = 1.0 - h[word] if h[word] >= 0.5
        end
        arr = h.to_a.sort{|x, y| x[1] <=> y[1]}
        words = arr[0, 15].collect{|x| x.first}

        result = words.inject({}){|h, w| h[w] = hash[w]; h}
      end
    end
  end
end

