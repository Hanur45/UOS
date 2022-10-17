# Shell file to compile code

# assemble boot.s file
as --32 boot.s -o boot.o
as --32 boot.s -o boot.o
as --32 load_gdt.s -o load_gdt.o
as --32 load_idt.s -o load_idt.o
# compile kernel.c file
gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O1 -Wall -Wextra

gcc -m32 -c utils.c -o utils.o -std=gnu99 -ffreestanding -O1 -Wall -Wextra
# compile idt.c file
gcc -m32 -c idt.c -o idt.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# compile isr.c file
gcc -m32 -c isr.c -o isr.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# compile gdt.c file
gcc -m32 -c gdt.c -o gdt.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
# linking all the object files to UOS.bin
ld -m elf_i386 -T linker.ld kernel.o utils.o gdt.o idt.o isr.o load_gdt.o boot.o -o UOS.bin -nostdlib

# check GUI_Box_OS.bin file is x86 multiboot file or not
grub-file --is-x86-multiboot UOS.bin

# building the iso file
mkdir -p isodir/boot/grub
cp UOS.bin isodir/boot/UOS.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o UOS.iso isodir

# run it in qemu
qemu-system-x86_64 -cdrom UOS.iso
