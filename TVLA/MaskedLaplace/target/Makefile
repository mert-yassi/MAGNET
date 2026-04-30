TARGET = MaskedLaplace

# List C source files here.
# Header files (.h) are automatically pulled in.
SRC += project.c
ASRC+= Refresh_m4.S SecNEG_m4.S SecA2B_m4.S SecB2A_m4.S SecINC_m4.S SecAND_m4.S MaskedBernoulli_m4.S MaskedGeometric_m4.S MaskedLaplace_m4.S

OPT = 0

# -----------------------------------------------------------------------------

ifeq ($(CRYPTO_OPTIONS),)
CRYPTO_OPTIONS = AES128C
endif

#Add simpleserial project to build
include ../../../firmware/mcu/simpleserial/Makefile.simpleserial

FIRMWAREPATH = ../../../firmware/mcu
include $(FIRMWAREPATH)/Makefile.inc
