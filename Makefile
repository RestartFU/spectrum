client:
	v -compress -skip-unused -gc none -cc gcc -cflags "-Wall -s -Os" cmd/spectrum -o spectrum
server:
	v -skip-unused -cg -gc none -cc gcc cmd/server -o server
all: server client