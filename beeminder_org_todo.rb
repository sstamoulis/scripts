#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2013
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

require "awesome_print"
require "beeminder"
require "highline/import"
require "org-ruby"
require "trollop"
require "yaml"

opts = Trollop::options do
  opt :pretend, "don't send data"
  opt :force,   "don't ask for confirmation, just update"
end

goal_dir = File.expand_path "~/projects/" 
goals = {
         :mavothi => "languages/mavothi.org"
        }

# simple handling of todos
class Orgmode::Headline
  def todo?
    ["TODO", "WAITING"].include? self.keyword
  end

  def done?
    ["DONE"].include? self.keyword
  end
end

config = YAML.load File.open("#{Dir.home}/.beeminderrc")
bee    = Beeminder::User.new config["token"]

goals.each do |goal, file|
  bee_goal = bee.goal goal.to_s
  cur_goal = bee_goal.curval.to_i
  tot_goal = bee_goal.goalval.to_i
  
  org  = Orgmode::Parser.new(File.open(File.join(goal_dir, file)).read)
  todo = org.headlines.count(&:todo?)
  done = org.headlines.count(&:done?)
  total = todo + done
  
  puts "#{goal} has #{todo} open tasks out of #{total} total."
  puts "Current Beeminder state is #{cur_goal} of #{tot_goal}."

  if tot_goal != total
    if opts[:force] or agree "Update goal total from #{tot_goal} to #{total}?"
      # dial road, leave rate untouched
      bee_goal.dial_road "goalval" => total, "rate" => bee_goal.rate unless opts[:pretend]
    end
  end

  if cur_goal != todo
    if opts[:force] or agree "Send diff of #{todo - cur_goal} as datapoint?"
      # send diff
      dp = Beeminder::Datapoint.new :value => (todo - cur_goal), :comment => "todo diff (#{todo} total)" 
      bee_goal.add dp unless opts[:pretend]
    end
  end
end
