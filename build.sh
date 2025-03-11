clear;

# ISO 9660 format
nasm 'source/sysarea.asm' -f bin -o 'build/sysarea.bin';
nasm 'source/voldesc.asm' -f bin -o 'build/voldesc.bin';
nasm 'source/lptab.asm' -f bin -o 'build/lptab.bin';
nasm 'source/mptab.asm' -f bin -o 'build/mptab.bin';
nasm 'source/rootdir.asm' -f bin -o 'build/rootdir.bin';

# Combine binaries
cat 'build/sysarea.bin' 'build/voldesc.bin' 'build/lptab.bin' 'build/mptab.bin' 'build/rootdir.bin' > 'images/disk1.iso';

# Resize disk image
python 'diskresize.py';