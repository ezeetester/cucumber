require 'cucumber/parser/natural_language'
require 'cucumber/filter'

module Cucumber
  module Parsers
    class Gherkin
      attr_reader :content, :adverbs
      
      LANGUAGE_PATTERN = /language\s*:\s*(.*)/ #:nodoc:
      
      def initialize(content, path, lines)
        @content, @path, @lines = content, path, lines
      end
      
      # Parses a file and returns a Cucumber::Ast
      # If +options+ contains tags, the result will
      # be filtered.
      def parse(options)
        filter = Filter.new(@lines, options)
        language = load_natural_language(lang || options[:lang] || 'en')
        @adverbs = language.adverbs
        language.parse(content, @path, filter)
      end
      
      def lang
        line_one = content.split(/\n/)[0]
        if line_one =~ LANGUAGE_PATTERN
          $1.strip
        else
          nil
        end
      end
      
      def load_natural_language(lang)
        Parser::NaturalLanguage.get(lang)
      end
    end
  end
end