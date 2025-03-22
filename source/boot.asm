org 0x7c00
bits 16
cpu 186

jmp main
%include 'include/boot.inc'

main:

error:
    mov si, booterrmsg
    call printstr
hang:
    cli
    hlt

booterrmsg: db 13, 10, 'Boot error, press a key to reboot', 0

times 2048-($-$$) db 0