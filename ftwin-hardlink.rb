#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2011
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "fileutils"

# connect all files in block
def hardlink(block)
  return if block.size < 2

  target = block.first
  
  block[1..-1].each do |file|
    puts "#{target} -> #{file}"
    FileUtils.rm(file)
    FileUtils.ln(target, file)
  end
end

block = []

ARGF.each do |line|
  line.chomp!
  
  if line.empty?
    hardlink(block)
    # start new block
    block = []
  else
    block << line
  end
end
