module Util
  CORPUS_ROOT = File.join(File.dirname(__FILE__), '..', 'corpus')

  def self.build_dictionary(name, order)
    MarkyMarkov::Dictionary.new(name, order).tap do |markov|
      Dir["#{CORPUS_ROOT}/*"].each do |filename|
        markov.parse_file(filename)
      end
    end
  end
end
