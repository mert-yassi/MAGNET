CC=gcc
COMMON_CFLAGS=-O3 -march=native -Wall -I.
CFLAGS=$(COMMON_CFLAGS)
LDFLAGS=-lm

OBJS=cpucycles.o fastrandombytes.o gaussian_avx.o hash.o keygen.o mint.o poly_mult.o poly_q.o randombytes.o sammat.o sampleb.o setup.o spend.o test.o verify.o utils.o params.o gadgets.o masked_algorithms.o base_gadgets.o sign_gadgets.o params-GR19.o utils-GR19.o

PROGRAM=ringct

all: magnet

magnet:
	$(MAKE) clean
	$(MAKE) $(PROGRAM) CFLAGS="$(COMMON_CFLAGS) -DMAGNET_"

gr19:
	$(MAKE) clean
	$(MAKE) $(PROGRAM) CFLAGS="$(COMMON_CFLAGS) -DGR19"

$(PROGRAM): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(PROGRAM) $(LDFLAGS) libXKCP.a

clean:
	rm -f *.o $(PROGRAM)
