
vpath %.asm src
vpath %.inc include

CP          = cp -f -u
RM          = rm -f

OBJS        = main.o
LSTS        = $(patsubst %.o,%.lst,$(OBJS))

###############################################################################
#
#                         Debug Settings
#
###############################################################################
#
#  AS          = nasm
#  ASFLAGS     = -gdwarf -f elf64
#
#  LD          = ld
#  LDFLAGS     = -nostdlib -b elf64-x86-64
#
###############################################################################

###############################################################################
#
#                        Release Settings
#
###############################################################################
#
AS          = nasm
ASFLAGS     = -f elf64 -Ox 
#
LD          = ld
LDFLAGS     = -nostdlib -b elf64-x86-64 --no-dynamic-linker -O --strip-all \
#              --discard-all --reduce-memory-overheads --relax 
#
###############################################################################

TARGET      = random

DUMP        = objdump
DFLAGS      = -D -x -s
DUMPFILE    = $(TARGET)-$(DUMP)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	strip --strip-all ./$(TARGET)

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

listings: $(LSTS)

%.lst: %.asm
	$(AS) $(ASFLAGS) -l $@ $^

dump:
	$(DUMP) $(DFLAGS) $(TARGET) | cat -n > $(DUMPFILE)

.PHONY: clean
clean:
	$(RM) $(OBJS) $(LSTS) $(DUMPFILE) $(TARGET)

.PHONY: install
install: $(TARGET)
	$(CP) ./$(TARGET) /usr/bin

.PHONY: uninstall
uninstall:
	$(RM) /usr/bin/$(TARGET)

