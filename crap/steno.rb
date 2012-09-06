#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "awesome_print"

wordlist = File.open("#{Dir.home}/in/randomstuff/wordlists/en.txt").map{|l| l.split.first}
text     = File.open("steno_test.txt").readlines.join.strip.downcase

words = text.split(/\s+/).map{|w| w.split(/\b/) + [" "]}.flatten[0..-2]

# find candidates based on start of word
class SimpleDictionary
  def initialize wordlist
    @wordlist = wordlist
    @cand_cache = {}
  end

  def candidates typed
    if not @cand_cache.include? typed
      @cand_cache[typed] = _candidates typed
    end
    
    @cand_cache[typed]
  end

  def _candidates typed
    list = @cand_cache[typed[0..-2]] || @wordlist
    list.select{|w| w.start_with? typed}
  end
end

class SmartDictionary < SimpleDictionary
  def _candidates typed
    list = @cand_cache[typed[0..-2]] || @wordlist
    list.select{|w| w =~ /^#{typed.chars.to_a.join(".*")}/}
  end
end

def naive_typing words
  words.reduce(0) {|sum, w| sum + w.chars.to_a.size}
end

def dict_typing words, wordlist
  strokes = 0

  dict = SimpleDictionary.new wordlist
  # dict = SmartDictionary.new wordlist

  num_cands = 5
  
  words.each do |word|
    i = 0
    len = word.chars.to_a.size
    while i < len
      # how much have we typed so far?
      typed = word[0,i]

      # find best candidates
      candidates = dict.candidates(typed).take num_cands
      # puts "#{typed} (#{word}) -> #{candidates}"
      
      num = candidates.index word
      if not num.nil? and num < num_cands
        # need to select word
        i += num == 0 ? 0 : 1
        # done typing
        break
      end
      
      i += 1
    end
    # puts "#{word} -> #{i}"
    strokes += i
  end
  
  strokes
end

naive_strokes = naive_typing words
dict_strokes = dict_typing words, wordlist
wpm = 70.0
speedup = naive_strokes.to_f / dict_strokes.to_f

puts "Typing #{words.reject{|w| w.empty?}.size} words..."
puts "Naive typing: #{naive_strokes} keystrokes."
puts "Using a dictionary: #{dict_strokes} keystrokes."
puts "Speedup: %0.2f." % speedup
puts "If you type at #{wpm.to_i}wpm, using a dictionary would speed you up to #{(speedup * wpm).to_i}wpm."
