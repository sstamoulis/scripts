#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright muflax <muflax@gmail.com>, 2009
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

import random

def make_one_dollar():
    debt = 1
    i = 1
    while random.random() < 0.5:
        debt *= 2
        i += 1
    return (debt, i)

def main():
    n = 1000
    m = 0
    games = 0
    for x in range(n):
        debt, i = make_one_dollar()
        games += i
        m = max(m, debt)
    print("Made %d$ after %d games. I needed %d$ to pull it off." % (n, games, m)) 

if __name__ == "__main__":
    main()

