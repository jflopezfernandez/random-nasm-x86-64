
vpath %.asm src
vpath %.inc include

OBJS        = main.o

AS          = nasm
ASFLAGS     = -Wall -f elf64 -l main.lst -O0 -g -F dwarf

LD          = ld
LDFLAGS     = --strip-all --format elf64-x86-64 --warn-common --gc-sections

CC          = gcc-9.1.0
CFLAGS      = 
CPPFLAGS    = 

TARGET      = random

all: $(TARGET)

$(TARGET): main.o
	$(LD) $(LDFLAGS) -o $@ $<

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

.PHONY: clean
clean:
	$(RM) $(wildcard *.o) $(wildcard *.pp) $(wildcard *.lst) $(TARGET)
