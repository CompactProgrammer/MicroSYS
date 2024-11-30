clear;

# SYSFS format & bootloader
nasm 'source/bootblock.asm' -f bin -o 'build/bootblock.bin';
nasm 'source/rootdir.asm' -f bin -o 'build/rootdir.bin';

# MicroSYS core
nasm 'source/microsys.asm' -f bin -o 'build/microsys.bin';

# Combine binaries
cat 'build/bootblock.bin' 'build/rootdir.bin' 'build/microsys.bin' > 'images/disk1.img';

# Convert to floppy disk image
python 'fdiskimg.py';