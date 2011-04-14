#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Copyright muflax <mail@muflax.com>, 2010
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>

def main():
    income = 3000
    expenses = 1700
    sav_rate = 1.05
    
    savings = 0
    year = 0
    payoff = 0
    while payoff < expenses:
        print("savings: %d, payoff: %d, year: %d" % (savings, payoff, year))
        payoff = (savings * 0.03) / 12
        savings *= sav_rate
        savings += 12 * (income - expenses)
        #savings += payoff * 12
        year += 1

if __name__ == "__main__":
    main()

