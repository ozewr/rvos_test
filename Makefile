K = kernel/lib
U = user

OBJS =  \
	$K/entry.o \
	$K/os.o		\
	$K/sbi.o    \
	$K/print.o	\
	$K/start.o \
	$K/utils.o \
	$K/lock.o \

OBJSS =  \
	$K/os.o		\
	$K/sbi.o    \
	$K/print.o	\
	$K/start.o  \
	$K/utils.o \
	$K/lock.o \

LD = riscv64-linux-gnu-ld 
CC = riscv64-linux-gnu-gcc
AS = riscv64-linux-gnu-as

INC = -I./kernel/include

OBJDUMP = riscv64-linux-gnu-objdump
OBJCOPY = riscv64-linux-gnu-objcopy

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -nostdlib -fno-builtin -mcmodel=medany
CFLAGS += -MD -ffreestanding -fno-common -mno-relax -I.

QEMU = qemu-system-riscv64
QFLAGS = -nographic -smp 3 -machine virt 
QFLAGS += -bios default
#QFLAGS += -bios /home/light/workplace/opensbi/build/platform/generic/firmware/fw_payload.elf
$K/kernel : $(OBJS) $K/os.ld 
	@$(LD)  -T $K/os.ld -o $K/kernel $(OBJS)
	@echo "LD+"
	@$(OBJDUMP) -S $K/kernel > $K/kernel.asm
	@echo "DUMP+"
	@$(OBJDUMP) -t $K/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $K/kernel.sym
	@echo "DUMP+"

$K/entry.o : $K/entry.s 
	@$(CC)  $(CFLAGS) -c $K/entry.s -o $K/entry.o	
	@echo "CC+"

all: $(OBJSS)
$(OBJSS): $K/%.o: $K/%.c
	@$(CC) -c $(CFLAGS) $(INC) $< -o $@
	@echo "CC+"


.PHONY: qemu
qemu: $K/kernel
	@echo "Press Ctrl-A and then X to exit QEMU"
	@$(QEMU) $(QFLAGS) -kernel $K/kernel

qemu-gdb:$K/kernel
	$(QEMU) $(QFLAGS)  -kernel $K/kernel -S -gdb tcp::26000

clean:
	rm $(OBJSS)  $K/kernel \
	$K/kernel.*	\
	$K/entry.o \
	$K/*.d
