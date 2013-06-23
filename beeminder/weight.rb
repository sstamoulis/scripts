#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "beeminder"

if ARGV.empty?
  puts "usage: weight.rb 80.5"
  exit 1
end

weight = ARGV.shift.to_f 

# sanity check
unless weight.between? 50, 100
  puts "invalid weight: #{weight}"
  exit 1
end

puts "connecting to beeminder..."
config = YAML.load File.open("#{Dir.home}/.beeminderrc")
bee    = Beeminder::User.new config["token"]

puts "sending weight..."
bee.send "weight",   weight

puts "updating weighhing..."
bee.send "weighing", 1
