# Double precision Cephes library
# Makefile for unix or GCC

CC = gcc
CFLAGS = -g -O2 -Wall -fno-builtin
AR = ar
RANLIB = ranlib
INCS = src/mconf.h
AS = as

OBJS = src/acosh.o src/airy.o src/asin.o src/asinh.o src/atan.o src/atanh.o src/bdtr.o src/beta.o \
src/btdtr.o src/cbrt.o src/chbevl.o src/chdtr.o src/clog.o src/cmplx.o src/const.o \
src/cosh.o src/dawsn.o src/drand.o src/ellie.o src/ellik.o src/ellpe.o src/ellpj.o src/ellpk.o \
src/exp.o src/exp10.o src/exp2.o src/expn.o src/fabs.o src/fac.o src/fdtr.o \
src/fresnl.o src/gamma.o src/gdtr.o src/hyp2f1.o src/hyperg.o src/i0.o src/i1.o src/igami.o \
src/incbet.o src/incbi.o src/igam.o src/isnan.o src/iv.o src/j0.o src/j1.o src/jn.o src/jv.o src/k0.o src/k1.o \
src/kn.o src/log.o src/log2.o src/log10.o src/lrand.o src/nbdtr.o src/ndtr.o src/ndtri.o src/pdtr.o \
src/polevl.o src/polmisc.o src/polyn.o src/pow.o src/powi.o src/psi.o src/rgamma.o src/round.o \
src/shichi.o src/sici.o src/sin.o src/sindg.o src/sinh.o src/spence.o src/stdtr.o src/struve.o \
src/tan.o src/tandg.o src/tanh.o src/unity.o src/yn.o src/zeta.o src/zetac.o \
src/sqrt.o src/floor.o src/setprec.o src/mtherr.o

all: libmd.a

#mtst dtestvec dcalc para

stamp-timing: libmd.a mtst time-it
	time-it "mtst > /dev/null"
	touch stamp-timing

time-it: time-it.o
	$(CC) -o time-it time-it.o

time-it.o: time-it.c
	$(CC) -O2 -c time-it.c

dcalc: dcalc.o libmd.a
	$(CC) -o dcalc dcalc.o libmd.a
#	aout2exe mtst

mtst: mtst.o libmd.a
	$(CC) -v -o mtst mtst.o libmd.a
#	gcc -Wl,-verbose -b i486-linuxaout -v -o mtst mtst.o libmd.a
#	coff2exe mtst

mtst.o: mtst.c
	$(CC) -O2 -Wall -c mtst.c

dtestvec: dtestvec.o libmd.a
	$(CC) -o dtestvec dtestvec.o libmd.a

dtestvec.o: dtestvec.c
	$(CC) -g -c dtestvec.c

paranoia: paranoia.o setprec.o libmd.a
	$(CC) -o paranoia paranoia.o setprec.o libmd.a

paranoia.o: paranoia.c
	$(CC) $(CFLAGS) -c paranoia.c

libmd.a: $(OBJS) $(INCS)
# for real Unix:
	$(AR) rv libmd.a $(OBJS)
# for djgcc MSDOS:
#	>libmd.rf -rv libmd.a $(OBJS)
#	$(AR) @libmd.rf
	$(RANLIB) libmd.a

# If the following are all commented out, the C versions
# will be used by default.

# IBM PC:
#sqrt.o: sqrt.387
#	$(AS) -o sqrt.o sqrt.387
#
#floor.o: floor.387
#	$(AS) -o floor.o floor.387
#
#setprec.o: setprec.387
#	$(AS) -o setprec.o setprec.387

# ELF versions for linux (no underscores)
#sqrt.o: sqrtelf.387
#	$(AS) -o sqrt.o sqrtelf.387

#floor.o: floorelf.387
#	$(AS) -o floor.o floorelf.387

#setprec.o: setprelf.387
#	$(AS) -o setprec.o setprelf.387

# Motorola 68881. Caution, subroutine return conventions vary.
#sqrt.o: sqrt.688
#	$(AS) -o sqrt.o sqrt.688
#
#setprec.o: setprec.688
#	$(AS) -o setprec.o setprec.688

# SPARC:
#sqrt.o: sqrt.spa
#	$(AS) -o sqrt.o sqrt.spa

clean:
	rm -f *.o
	rm -f mtst
	rm -f paranoia
	rm -f dcalc
	rm -f libmd.a
	rm -f time-it
	rm -f dtestvec

