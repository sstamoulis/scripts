#!/usr/bin/env python3
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

# simulate some simple point systems for positive reinforcements

import random

def roll_dice(dice=10):
  return random.choice(range(1,dice+1))

def main():
  num_habits = 3
  die = 20
  reward_thres = 50
  thres_increase = 5
  max_days = 30

  habits = [0]*num_habits
  day = 0
  reward_num = 0
  while day < max_days:
    day += 1
    rewarded = False
    for i,h in enumerate(habits):
      habits[i] += roll_dice(die)
      if habits[i] >= reward_thres and not rewarded:
        habits[i] -= reward_thres
        rewarded = True
        reward_num += 1
        reward_thres += thres_increase
        print("Reward (%d)!" % i)

    print("Day %d: %s (sum: %s)" % (day, habits, sum(habits)))

  print("total rewards: %d, avg days/reward: %0.2f" % (reward_num,
                                                       max_days/reward_num))

if __name__ == "__main__":
  main()
