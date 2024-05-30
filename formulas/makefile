CC = gcc
CFLAGS = -Wall -g 

all: main

main: main.c formula2.s formula1.c
	$(CC) $(CFLAGS) -o main main.c formula2.s formula1.c -lm

run: main
	./main
clean:
	rm -f main

debug: main
	gdb main