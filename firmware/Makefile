PREFIX = riscv64-elf-
CC = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy

ARCH = -march=rv32im_zicsr_zifencei -mabi=ilp32
CFLAGS = $(ARCH) -ffreestanding -nostdlib -nostartfiles -O2 -Wall
LDFLAGS = -T link.ld -nostdlib -nostartfiles -Wl,-e,_start

all: firmware.mem firmware.bin

firmware.elf: crt0.S main.c
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

firmware.mem: firmware.elf
	$(OBJCOPY) -O verilog --verilog-data-width=4 $< $@

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f firmware.elf firmware.mem firmware.bin
