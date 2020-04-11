# frozen_string_literal: true

class DictionaryLoader
  def self.make_dictionary(dictionary_path)
    dictionary = DictionaryTrie.new
    File.open(dictionary_path).each { |word| dictionary.insert(word.chomp.upcase) }
    dictionary
  end
end
