AS	:= nasm
QEMU	:= qemu-system-i386
OBJDUMP	:= objdump

ASFLAGS	:= -f bin
OBJFLAG	:= -D -Mintel,i8086 -b binary -mi386 --adjust-vma=0x7c00
QFLAGS	:= --nographic -s -hda

TARGET	:= boot.bin




all:	$(TARGET)
	make run

clean:
	$(RM) *.bin

run:	$(TARGET)
	$(QEMU) $(QFLAGS) $^

dump:	$(TARGET)
	clear
	$(OBJDUMP) $(OBJFLAG) $^



%.bin:	%.asm
	$(AS) $(ASFLAGS) -o $@ $<
