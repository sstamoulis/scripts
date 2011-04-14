#!/usr/bin/python

GOAL_LENGTH = 20

import random

class Evolve(object):
    def __init__(self, goal_length, goals, ttl):
        # the advantageous state
        self.goal_length = goal_length
        self.goals = set(["%0*d" % (goal_length, random.randint(0,10**goal_length))
                          for x in range(goals)])
        self.tries = 0
        self.ttl = ttl
        print(("goals:", self.goals))

    def live(self, number):
        lifeforms = set([Lifeform(self.ttl, self.goal_length, self.goals) 
                         for x in range(number)])
        while lifeforms:
            for lifeform in list(lifeforms):
                lifeform.mutate()
                if lifeform.goal_reached():
                    print(("goal reached in %d global and %d local tries." % 
                           (self.tries, lifeform.tries)))
                    lifeforms.remove(lifeform)
                elif not lifeform.is_alive():
                    lifeforms.remove(lifeform)
                    lifeforms.add(Lifeform(self.ttl, self.goal_length,
                                           self.goals))
            self.tries += 1
        print("Everyone is dead, Dave.")

class Lifeform(object):
    def __init__(self, ttl, goal_length, goals):
        self.ttl = ttl
        self.state = [["?", 0.0] for x in range(goal_length)]
        self.goal_length = goal_length
        self.goals = goals
        self.tries = 0
    
    def goal_reached(self):
        return "".join([x[0] for x in self.state]) in self.goals

    def mutate(self):
        for digit in range(self.goal_length):
            if random.random() > self.state[digit][1]: #self.state[digit] == "?":
                mutation = str(random.randint(0,9))
                for goal in self.goals:
                    if goal[digit] == mutation: # partial match
                        self.state[digit] = [mutation, 0.0] # remember it
                        if digit > 1 and goal[digit-1] == self.state[digit-1][0]:
                            self.state[digit][1] += 0.5
                        if digit < self.goal_length-1 and goal[digit+1] == self.state[digit+1][0]:
                            self.state[digit][1] += 0.5

            self.tries += 1
            #print "".join(self.state)

    def is_alive(self):
        return self.ttl > self.tries

def main():
    e = Evolve(goal_length=20, goals=2, ttl=1000)
    e.live(10)

if __name__ == "__main__":
    main()
