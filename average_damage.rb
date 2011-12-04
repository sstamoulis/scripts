#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "range_math"

def dice(num, sides)
  num * (1..sides)   
end

input = ARGV.join " "
input.gsub!(/(\d+)d(\d+)/, '(dice(\1, \2))')
damage = eval(input)
puts "range: #{damage}, average: #{damage.average}"
