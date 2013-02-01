CC=gcc
CFLAGS=-g -Wall -ansi -std=c99 -O2
LDFLAGS=

all: dmplex 

include Makefile.dep

.o: %.c
	$(CC) $(CFLAGS) -c $(<) -o $@

dmplex: dmplex.o $(FILES)
	$(CC) $(LDFLAGS) $(CFLAGS) $(^) -o $(@)

clean: 
	$(RM) *.o

.PHONY: all clean
