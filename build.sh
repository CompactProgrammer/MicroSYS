# SYSFS format
nasm 'source/bootblock.asm' -f bin -o 'build/bootblock.bin';
nasm 'source/eft.asm' -f bin -o 'build/eft.bin';
nasm 'source/rootdir.asm' -f bin -o 'build/rootdir.bin';

# Bootloader
nasm 'source/bootldr.asm' -f bin -o 'build/bootldr.bin';

# Combine binaries
cat 'build/bootblock.bin' 'build/eft.bin' 'build/rootdir.bin' 'build/bootldr.bin' > 'images/disk1.img';

# Convert to 1.2MB floppy disk image
python 'fdiskimg.py'