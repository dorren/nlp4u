require 'nokogiri'

module Nlp4u
  module Tokenizers
    class SpaceTokenizer
      class << self
        def strip_html(html)
          content = Nokogiri::HTML(html)
          content.search("//text()").text
        end

        # convert block of text to array of words.
        def tokenize(text)
          text.downcase.split(/[\s\.,"']+/)
        end
      end
    end
  end
end
