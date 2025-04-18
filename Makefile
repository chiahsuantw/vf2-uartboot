RISCVGNU ?= riscv64-unknown-elf
CFLAGS = -march=rv64gc -ffreestanding -mcmodel=medany -fPIE

build: clean
	$(RISCVGNU)-gcc $(CFLAGS) -c *.S *.c
	$(RISCVGNU)-ld -T linker.ld -o kernel.elf *.o
	$(RISCVGNU)-objcopy -O binary kernel.elf kernel.bin
	mkimage -f kernel.its kernel.fit

clean:
	rm -f *.o *.elf *.bin *.fit
