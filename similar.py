#!/usr/bin/env python

# the idea is to compare two words, and measure how similar they are on a keyboard.
# this can be done by evaluating how close their letters are from one another.

from math import sqrt
import psyco 

#Initilization

total_total_distance_q = 0.0
total_total_distance_d = 0.0
q_count_close = 0.0
d_count_close = 0.0

qwerty = "qwertyuiop 0asdfghjkl 00zxcvbnm"
dvorak = "000pyfgcrl 0aoeuidhtns 000qjkxbmwvz"

qkey = {}
dkey = {}

row = 0
col = 0

for line in qwerty.split() :
    for character in line :
        qkey[character] = (row,col)
        col += 1
    row += 1
    col = 0
    
row = 0
col = 0
    
for line in dvorak.split() :
    for character in line :
        dkey[character] = (row,col)
        col += 1
    row += 1
    col = 0

#End init.

def qdistance(cone, ctwo):
    tone = qkey[cone]
    ttwo = qkey[ctwo]
    diff_r = abs(tone[0] - ttwo[0])
    diff_c = abs(tone[1] - ttwo[1])
    dist = sqrt(diff_c*diff_c + diff_r*diff_r)
    # print dist
    return dist

def ddistance(cone, ctwo):
    tone = dkey[cone]
    ttwo = dkey[ctwo]
    diff_r = abs(tone[0] - ttwo[0])
    diff_c = abs(tone[1] - ttwo[1])
    dist = sqrt(diff_c*diff_c + diff_r*diff_r)
    # print dist
    return dist

def compare_words(wone,wtwo):
    now_q_close_count = 0
    now_d_close_count = 0
    global q_count_close
    global d_count_close
    q_total_distance = 0
    d_total_distance = 0
    for i in range(len(wone)):
        q_distance = qdistance(wone[i],wtwo[i])
        d_distance = ddistance(wone[i],wtwo[i])
        if q_distance <= 1.5:
            now_q_close_count += 1
        if d_distance <=1.5:
            now_d_close_count += 1
        q_total_distance += q_distance
        d_total_distance += d_distance
    q_average = q_total_distance / len(wone)
    d_average = d_total_distance / len(wone)
    if now_q_close_count == len(wone) :
        q_count_close += 1
    if now_d_close_count == len(wone) :
        d_count_close += 1
    return q_average,d_average

def main(): 
    global total_total_distance_q
    global total_total_distance_d
    count =0
    tot_adv_close = tot_adv_dist = 0

    wordlist = open("words", "r")
    words = [set() for x in xrange(30)]


    for word in wordlist :
        word = word.strip().lower()
        words[len(word)].add(word)
        count += 1

    print "Words read into memory.",count,"words."

    for i in xrange(1,len(words)):
        
        word_array = list(words[i])
        pairs = 0.0
        for j in xrange(len(word_array)) :
            for k in xrange(j+1,len(word_array)):
                #compare the two selected words of the same length.
                dq,dd = compare_words(word_array[j],word_array[k])
                total_total_distance_q += dq
                total_total_distance_d += dd
                pairs += 1
        if pairs:
            tot_adv_dist = total_total_distance_q / total_total_distance_d
            tot_adv_close = d_count_close / q_count_close

            print "for",pairs,"pairs of",i,"letter words: "
            print "qwerty average difference:",total_total_distance_q / pairs
            print "dvorak average difference:",total_total_distance_d / pairs
            print "advantage of qwerty:",tot_adv_dist
            print "qwerty almost matches:", q_count_close / pairs, "=",q_count_close
            print "dvorak almost matches:", d_count_close / pairs, "=",d_count_close
            print "advantage of qwerty:",tot_adv_close
            print
        else: 
            print "no pairs for length", i
            print

    print "total advantage of qwerty for average differences:",tot_adv_dist
    print "total advantage of qwerty for almost matches:",tot_adv_close
    print "Done."

psyco.full()
main()
