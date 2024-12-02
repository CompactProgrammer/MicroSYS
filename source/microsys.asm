org 0x0000
bits 16
cpu 286

jmp setup

%include 'include/video.inc'

setup:
    .segments:
        mov ax, 0
        mov ds, ax
        mov es, ax
    .video:
        mov ax, 2
        int 0x10
        call cls

main:
    mov si, welcomemsg
    call printstr

hang:
    cli
    hlt

welcomemsg: db 'MicroSYS$'

times 8192-($-$$) db 0