
vpath %.asm src
vpath %.inc include

OBJS        = main.o
LSTS        = $(patsubst %.o,%.lst,$(OBJS))

AS          = nasm
ASFLAGS     = -Wall -f elf64

LD          = ld
LDFLAGS     = -b elf64-x86-64

TARGET      = random

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

listings: $(LSTS)

%.lst: %.asm
	$(AS) $(ASFLAGS) -l $@ $^

.PHONY: clean
clean:
	$(RM) $(OBJS) $(LSTS) $(TARGET)

