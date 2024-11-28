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
    .wait:
        mov ah, 0x86
        mov cx, 0x001e
        mov dx, 0x8480
        int 0x15
    .donesetup:
        xchg bx, bx
        call newline

hang:
    cli
    hlt

startupmsg: db 'Starting MicroSYS...$'

%include 'include/boot.inc'

times 4096-($-$$) db 0