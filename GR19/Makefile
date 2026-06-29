CC = gcc
DEBUG = FALSE
MODE ?= TIME
order ?= 1

validate_order:
	@if ! printf '%s\n' "$(order)" | grep -Eq '^[1-9][0-9]*$$'; then \
		echo "Error: masking order must be >= 1."; \
		exit 1; \
	fi

CFLAGS = -O3 -march=native -fomit-frame-pointer -D$(MODE) -DMASKING_ORDER=$(order)
WARNINGS = -Wall -Wextra -Wimplicit-function-declaration -Wredundant-decls -Wmissing-prototypes -Wstrict-prototypes -Wundef -Wno-deprecated-declarations
LDFLAGS = -lm

ifeq ($(DEBUG),TRUE)
  CFLAGS += -DDEBUG
endif

SRC    := build.c
OBJDIR := objs
OBJ    := $(SRC:%.c=$(OBJDIR)/%.o)
TARGET := GR19-DGS

all: time

time: validate_order
	$(MAKE) clean
	$(MAKE) $(TARGET) MODE=TIME order=$(order)

verify: validate_order
	$(MAKE) clean
	$(MAKE) $(TARGET) MODE=VERIFY order=$(order)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(WARNINGS) $^ -o $@ $(LDFLAGS)

$(OBJDIR)/%.o: %.c | $(OBJDIR)
	$(CC) $(CFLAGS) $(WARNINGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

.PHONY: all time verify validate_order clean
clean:
	rm -rf $(OBJDIR) $(TARGET) samples.txt
