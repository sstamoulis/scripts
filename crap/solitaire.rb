#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "set"

words = Set.new File.open(ARGV.first).readlines.map(&:chop)

words.sort.each do |w|
  pos = 0
  until pos.nil?
    pos = w.index /[a]/, pos # only relevant matches
    unless pos.nil?
      match = true
      %w{e i o u}.each do |vowel|
        w2 = w[0..pos-1] + vowel + w[pos+1..-1]
        match &= words.include? w2
      end
      puts w if match
      pos += 1
    end
  end
end
