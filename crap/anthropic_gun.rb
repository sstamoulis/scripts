#!/usr/bin/env ruby
# coding: utf-8
# Copyright muflax <mail@muflax.com>, 2012
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

Loaded_prob = 0.50
Gun_prob    = 0.50
Exit_prob   = 0.75

games    = 10000
deaths   = 0
exits    = 0
rounds   = 10000
attempts = 0

def flip prob
  rand < prob
end

anthropic_updates = true

if not anthropic_updates
  def decide_to_quit round, gun_fired
    prob_loaded = Loaded_prob

    if prob_loaded < Exit_prob
      false # don't quit
    else
      true # quit
    end
  end
else
  def decide_to_quit round, gun_fired
    if gun_fired # we never quit with an empty gun
      false
    end

    prob_loaded = 1.0 - 1.0 / ((2**round) + 1)
    
    if prob_loaded < Exit_prob
      false # don't quit
    else
      true # quit
    end
  end
end

games.times do |game|
  loaded = flip Loaded_prob

  puts "game #{game+1}, gun #{loaded ? "loaded" : "not loaded"}"

  dead = false
  gun_fired = false
  
  rounds.times do |round|
    # one new agent-moment
    attempts += 1
    
    # play another round or not?
    quit = decide_to_quit round, gun_fired

    if quit
      # last chance to die
      if flip Exit_prob
        dead = true
      end
      # either way, we're done
      break
    else
      # gun or not?
    
      if flip Gun_prob
        gun_fired = true
        if loaded
          # we die here
          dead = true
          break
        end
      else
        # nothing happens
      end
    end
  end

  # game is over, did the agent survive?
  if dead
    deaths += 1
  else
    exits += 1
  end
end

puts "#{games} games, #{attempts} attempts, #{exits} exits, #{deaths} deaths."
puts "survival rate: %0.2f." % (exits.to_f / games.to_f)
puts "death rate: %0.2f." % (deaths.to_f / games.to_f)
