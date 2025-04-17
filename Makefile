RISCVGNU ?= riscv64-unknown-elf
CFLAGS = -march=rv64gc -ffreestanding -mcmodel=medany -Wall -g
QEMUFLAGS = -M virt -smp 5 -m 4G -kernel kernel.bin -display none -serial pty

build: clean
	$(RISCVGNU)-gcc $(CFLAGS) -c *.S *.c
	$(RISCVGNU)-ld -T linker.ld -o kernel.elf *.o
	$(RISCVGNU)-objcopy -O binary kernel.elf kernel.bin

clean:
	rm -f *.o *.elf *.bin *.fit

qemu: build
	qemu-system-riscv64 $(QEMUFLAGS)
