## This is a BSD make file.  If you're running GNU/Linux, you should use the GNU
## Makefile: make -f Makefile.gnu.

PRGS = codeml
CC = cc
LIBS = -lm # -lM (link to the math library)

.ifmake debug
   CFLAGS = -ggdb -O0
.elifmake check-syntax
   CFLAGS = 
.else 
   #CFLAGS = -O4 -funroll-loops -fomit-frame-pointer -finline-functions
.endif

all: $(PRGS)

check-syntax: $(PRGS)

debug: $(PRGS)

codeml: codeml.o tools.o
	$(CC) $(CFLAGS) -o $@ codeml.o tools.o $(LIBS)

tools.o: paml.h tools.c
	$(CC) $(CFLAGS) -c tools.c

codeml.o: paml.h codeml.c treesub.c treespace.c
	$(CC) $(CFLAGS) -c codeml.c

clean:
	rm -f ${PRGS} *.o *.core
