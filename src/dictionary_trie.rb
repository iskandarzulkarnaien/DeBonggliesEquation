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
  def is_in_trie(word_fragment)
    # Cleaner implementation, but less readable
    # word_fragment.empty? || (@sub_tries.key?(word_fragment[0]) && @sub_tries[word_fragment[0]].is_in_trie(word_fragment[1..-1]))

    # Todo: Find a way to refactor this such that it looks cleaner while remaining readable
    if word_fragment.empty?
      true
    elsif @sub_tries.key?(word_fragment[0])
      @sub_tries[word_fragment[0]].is_in_trie(word_fragment[1..-1])
    else
      false
    end
  end

  # Traverse trie to determine whether word_fragment is a valid word
  def is_valid_word(word)
    # Cleaner implementation, but less readable
    # (word.empty? && @is_complete_word) || (@sub_tries.key?(word[0]) && @sub_tries[word[0]].is_valid_word(word[1..-1]))

    # Todo: Find a way to refactor this such that it looks cleaner while remaining readable
    if word.empty?
      @is_complete_word
    elsif @sub_tries.key?(word[0])
      @sub_tries[word[0]].is_valid_word(word[1..-1])
    else
      false
    end
  end
end
