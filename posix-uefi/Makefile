ARCH	:= x86_64
SRCS	:= $(wildcard src/*.c)
CFLAGS	:= -pedantic -Wall -Wextra -Werror --ansi -O2

TARGET	:= main.efi


include uefi/Makefile



BIOS	:= OVMF.fd
DISK	:= image/EFI/BOOT/


qemu:		$(BIOS) $(DISK)
	qemu-system-x86_64 -nographic -bios $(BIOS) -drive file=fat:rw:image,media=disk,format=raw
	rm -rf $(DISK)

$(DISK):	$(TARGET)
	mkdir -p $@
	ln -sf ../../../$(TARGET) $@/BOOTX64.efi
