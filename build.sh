clear;

# SYSFS format
nasm 'source/bootblock.asm' -f bin -o 'build/bootblock.bin';
nasm 'source/bet.asm' -f bin -o 'build/bet.bin';
nasm 'source/rootdir.asm' -f bin -o 'build/rootdir.bin';

# MicroSYS kernel & bootloader
nasm 'source/sysboot.asm' -f bin -o 'build/sysboot.bin';
nasm 'source/syskernel.asm' -f bin -o 'build/syskernel.bin';

# Device drivers
nasm 'source/keyboard.asm' -f bin -o 'build/keyboard.bin';

# Combine binaries
cat 'build/bootblock.bin' 'build/bet.bin' 'build/rootdir.bin' 'build/sysboot.bin' 'build/syskernel.bin' 'build/keyboard.bin' > 'images/disk1.img';

# Convert to floppy disk image
python 'fdiskimg.py';