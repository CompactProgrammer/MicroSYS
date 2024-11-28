org 0x0000
bits 16
cpu 186

setup:
    .segments:
        mov ax, 0x0a00
        mov ds, ax
        mov es, ax
    .startmsg:
        mov si, startupmsg
        call printstr

hang:
    cli
    hlt

startupmsg: db 'Starting MicroSYS...$'

%include 'include/boot.inc'

times 4096-($-$$) db 0