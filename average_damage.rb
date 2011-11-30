#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

input = ARGV.join " "

if m = input.match(/(?<num> \d+) \s* d \s* (?<die> \d+) \s* ((?<sign> \+|-) \s* (?<mod> \d+))?/x)
  avg = eval "#{m[:num]} * ((#{m[:die]}+1)/2.0)"
  unless m[:sign].nil? or m[:mod].nil?
    avg += eval "#{m[:sign]}#{m[:mod]}"
  end
  puts avg
end
