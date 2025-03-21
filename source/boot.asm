org 0x1000
bits 16
cpu 186

jmp main
%include 'include/boot.inc'

main:

hang:
    cli
    hlt

booterrmsg: db 13, 10, 'Boot error, press a key to reboot', 0

times 6144-($-$$) db 0

iso9660buffer:

times 8192-($-$$) db 0