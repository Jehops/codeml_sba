PRGS = codeml_sba
CC = cc
LIBS = -lm # -lM (link to the math library)

ifeq ($(MAKECMDGOALS), debug)
CFLAGS = -ggdb
else
CFLAGS = -O3
endif

all: $(PRGS)

debug: $(PRGS)

codeml_sba: codeml.o tools.o
	$(CC) $(CFLAGS) -o $@ codeml.o tools.o $(LIBS)

tools.o: paml.h tools.c
	$(CC) $(CFLAGS) -c tools.c

codeml.o: paml.h codeml.c treesub.c treespace.c
	$(CC) $(CFLAGS) -c codeml.c

clean:
	rm -f ${PRGS} *.o *.core
