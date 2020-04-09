require_relative 'jsonable.rb'

class DictionaryTrie
  def initialize
    @sub_tries = {}           # A Trie is a hash of hashes.
    @is_complete_word = false # Indicate whether the trie's key, with its parent tries' keys, would form a valid word
  end

  def insert(word)
    # Empty word string indicates the word has successfully been added to the trie.
    if word.empty?
      @is_complete_word = true
      return
    end

    # Add every letter of the word to the trie
    @sub_tries[word[0]] ||= DictionaryTrie.new
    @sub_tries[word[0]].insert(word[1..-1])
  end

  # Traverse trie to determine whether word_fragment is present (i.e. part of a sub-trie)
  def is_in_trie?(word_fragment)
    # Cleaner implementation, but less readable
    # word_fragment.empty? || (@sub_tries.key?(word_fragment[0]) && @sub_tries[word_fragment[0]].is_in_trie?(word_fragment[1..-1]))

    # Todo: Find a way to refactor this such that it looks cleaner while remaining readable
    if word_fragment.empty?
      true
    elsif @sub_tries.key?(word_fragment[0])
      @sub_tries[word_fragment[0]].is_in_trie?(word_fragment[1..-1])
    else
      false
    end
  end

  # Traverse trie to determine whether word_fragment is a valid word
  def is_valid_word?(word)
    # Cleaner implementation, but less readable
    # (word.empty? && @is_complete_word) || (@sub_tries.key?(word[0]) && @sub_tries[word[0]].is_valid_word?(word[1..-1]))

    # Todo: Find a way to refactor this such that it looks cleaner while remaining readable
    if word.empty?
      @is_complete_word
    elsif @sub_tries.key?(word[0])
      @sub_tries[word[0]].is_valid_word?(word[1..-1])
    else
      false
    end
  end

  # Should do this first, because once you have this, can just call this on your regenerated Trie to check for correctness.
  def to_jsoned #changed name to jsoned to disambiguate for debug purposes
    hash = {}

    hash["subtries"] = {}
    @sub_tries.keys.each do |letter|
      hash["subtries"][letter] = @sub_tries[letter].to_jsoned
    end

    hash["is_complete_word"] = @is_complete_word
    
    JSON.pretty_generate(hash)
  end

  def from_json!(json)
    # subtries, is_complete_word
    subtries = json["subtries"] # each elem is a letter, each letter is a json
    is_complete_word = json["is_complete_word"]

    subtries.each do |letter|
      @sub_tries[letter] ||= DictionaryTrie.new
      @sub_tries[letter].from_json!(JSON.load(subtries[letter])) unless subtries[letter].nil?
    end
    @is_complete_word = is_complete_word
  end

  # {
  #   "highscore": 0,
  #   "dictionary": {
  #     "subtries": {
  #       "r": {
  #         "subtries": {
  #           "e": {
  #             "subtries": {
  #               "a": {
  #                 "subtries": {
  #                   "d": {
  #                     "subtries": {},
  #                     "is_complete_word": true
  #                   }
  #                 },
  #                 "is_complete_word": false
  #               },
  #               "e":{
  #                 "subtries": {
  #                   "d": {
  #                     "subtries": {},
  #                     "is_complete_word": true
  #                   }
  #                 },
  #                 "is_complete_word": false
  #               },
  #               "d": {
  #                 "subtries": {},
  #                 "is_complete_word": true
  #               }
  #             },
  #             "is_complete_word": false
  #           },
  #           "o": {
  #             "subtries": {
  #               "p": {
  #                 "subtries": {
  #                   "e": {
  #                     "subtries": {},
  #                     "is_complete_word": true
  #                   }
  #                 },
  #                 "is_complete_word": false
  #               }
  #             },
  #             "is_complete_word": false
  #           }
  #         },
  #         "is_complete_word": false
  #       }
  #     },
  #     "is_complete_word": false
  #   }
  # }

end
