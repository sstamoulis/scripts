#!/usr/bin/env python
# encoding: utf-8
import random

def roll3():
    char = [0]*6
    for i in range(len(char)):
        throws = [random.randint(1,6),
                  random.randint(1,6),
                  random.randint(1,6),
                  random.randint(1,6)]
        throws.sort()
        char[i] = sum(throws[1:])
    return char

def roll2():
    char = [0]*6
    for i in range(len(char)):
        char[i] = (random.randint(1,6) + random.randint(1,6) +
                   random.randint(1,6))
    return char

print(("2:", roll2()))
print(("3:", roll3()))

