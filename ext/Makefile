
CC=gcc
CFLAGS=-Wno-unused-value

all: clean pngdefry.o

pngdefry.o:
	$(CC) $(CFLAGS) -c pngdefry.c -o $@

clean:
	rm -rf pngdefry *.o *.a