
vpath %.asm src
vpath %.inc include

OBJS        = main.o

AS          = nasm
ASFLAGS     = -Wall -f elf64 -l main.lst -Ov
TARGET_MACH = x86_64

LD          = ld
LDFLAGS     = --strip-all --format elf64-x86-64 --warn-common --gc-sections

CC          = gcc-9.1.0
CFLAGS      = 
CPPFLAGS    = 

TARGET      = random

all: $(TARGET)

$(TARGET): main.o
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

.PHONY: clean
clean:
	$(RM) $(wildcard *.o) $(TARGET)
