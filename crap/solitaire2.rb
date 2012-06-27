#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "set"

words = Set.new File.open(ARGV.first).readlines.map(&:chop)
matches = Hash.new {|h,k| h[k] = Set.new}

words.sort.each do |w|
  (0...w.length).each do |pos|
    # stupid but fast enough
    match = w.dup
    match[pos] = "?"
    matches[match] << w
  end
end

results = matches.values.group_by {|s| s.size}
results.keys.sort.each do |l|
  puts "#{results[l].size} sets of length #{l}"
end

largest = results.keys.max
results[largest].each do |set|
  w = set.sort
  puts "#{w.first} -> #{w}"
end
