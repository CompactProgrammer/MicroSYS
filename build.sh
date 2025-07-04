clear;

rm -r build;
mkdir build;

# ISO 9660 format
nasm 'source/sysarea.asm' -f bin -o 'build/sysarea.bin';
nasm 'source/voldesc.asm' -f bin -o 'build/voldesc.bin';
nasm 'source/bootcat.asm' -f bin -o 'build/bootcat.bin';
nasm 'source/lptab.asm' -f bin -o 'build/lptab.bin';
nasm 'source/mptab.asm' -f bin -o 'build/mptab.bin';

# Root directory
nasm 'source/rootdir.asm' -f bin -o 'build/rootdir.bin';
nasm 'source/boot.asm' -f bin -o 'build/boot.bin';
nasm 'source/kernel.asm' -f bin -o 'build/kernel.bin';

# MICROSYS directory
nasm 'source/microsysdir.asm' -f bin -o 'build/microsysdir.bin';
nasm 'source/config.asm' -f bin -o 'build/config.bin';
nasm 'source/keybrd.asm' -f bin -o 'build/keybrd.bin';
nasm 'source/cmdprmpt.asm' -f bin -o 'build/cmdprmpt.bin';

# Combine binaries
cat 'build/sysarea.bin' 'build/voldesc.bin' 'build/bootcat.bin' 'build/lptab.bin' 'build/mptab.bin' 'build/rootdir.bin' 'build/boot.bin' 'build/kernel.bin' 'build/microsysdir.bin' 'build/config.bin' 'build/keybrd.bin' 'build/cmdprmpt.bin' > 'images/disk1.iso';

# Resize disk image
python 'diskresize.py';