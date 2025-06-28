org 0x0000
bits 16
cpu 186

pib:
    .reserved0: db 0
    .mem: dw 0x0080
    .parentseg: dw 0x0c00
    .ftable: times 16 db 0
    .segment: dw 0x0c00
    .exitcode: dw 0
    .parentoff: dw 0
    .prgmstart: dw setup
    .reserved1: times 98 db 0
    .cmdargslen: db 0
    .cmdargs: times 127 db 0

%include 'include/video.inc'

setup:
    call cls
    .segments:
        mov ax, [pib.segment]
        mov ds, ax
        mov es, ax
    .version:
        mov si, vermsg
        call printstr
        mov ah, 0x04
        int 0x40
        mov bh, ah
        mov bl, al
        mov ah, 0x0e
        mov al, bh
        int 0x10
        mov al, '.'
        int 0x10
        mov al, bl
        int 0x10
        mov si, vermsg.1
        call printstr

hang:
    cli
    hlt

vermsg:
    .0: db 'MicroSYS version ', 0
    .1: db 13, 10, 13, 10, 0

times 2048-($-$$) db 0