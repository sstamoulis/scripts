#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# Solves the final puzzle in Primordia. :)

require "set"

@fragments = %w{ 03067 440 26 0248 102 675 4024 02 }
@length = @fragments.join.size
@possibilities = Set.new

def mergify code, fragments
  # first, check if we have a complete code to print

  return if code.size > @length # find the shortest possible result

  if fragments.empty? and code.size <= @length
    if code.size < @length
      @length = code.size
      puts "new max length: #{@length}"
    end
    @possibilities << code
  end

  # next, generate all possible variations
  fragments.each.with_index do |f, i|
    # new fragments
    new_fragments = fragments[0,i] + fragments[(i+1)..-1]
    
    # possible ways to merge it
    variants = []

    # merge from the left
    (0..f.size).each do |j|
      a = f[0,j]
      b = f[j..-1]

      variants << a+code if code.start_with? b
      variants << code+b if code.end_with? a
    end
    
    # also consider a complete overlap
    variants << code if code.include? f
    
    # shrink possibilities
    variants.uniq!

    # recursion!
    variants.each do |new_code|
      mergify(new_code, new_fragments)
    end
  end
end

# find solutions
mergify "", @fragments

# remove long options
@possibilities.reject! {|p| p.size > @length}

@possibilities.sort.each do |poss|
  puts "possible code: #{poss}"
end

puts "found #{@possibilities.size} possible codes of length #{@length}."
