#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "beeminder"
require "csv"
require "fume"
require "yaml"

use_bee = false
use_csv = false

if use_bee
  puts "bee..."
  config   = YAML.load File.open("#{Dir.home}/.beeminderrc")
  bee      = Beeminder::User.new config["token"]
  bee_goal = bee.goal "fumeavg"
  # clean up goal
  # dps = bee_goal.datapoints
  # bee_goal.delete dps
end

puts "fume..."
fumes = Fume::Fumes.new
fumes.init

puts "getting data..."
cutoff = Date.parse "2011-04-04"

CSV.open("bayes.csv", "w") do |csv|
  cutoff.upto(Date.today).each do |day|
    dur = fumes.durations[:all][day]
    puts "day: #{day}"
    dur /= 3600
    
    csv << [day, dur] if use_csv
    
    if use_bee
      puts "sending..."
      dp = Beeminder::Datapoint.new("timestamp" => day.strftime('%s'),
                                    "value"     => dur,
                                    "comment"   => "fume automatic update")
      bee_goal.add dp
    end
  end
end
