TARGET = SecINC

# List C source files here.
# Header files (.h) are automatically pulled in.
SRC += project.c
ASRC+= SecBA_m4.S SecAB_m4.S SecINC_m4.S

OPT = 0

# -----------------------------------------------------------------------------

ifeq ($(CRYPTO_OPTIONS),)
CRYPTO_OPTIONS = AES128C
endif

#Add simpleserial project to build
include ../../../firmware/mcu/simpleserial/Makefile.simpleserial

FIRMWAREPATH = ../../../firmware/mcu
include $(FIRMWAREPATH)/Makefile.inc
