org 0x0000
bits 16
cpu 186

jmp setup

%include 'include/boot.inc'

setup:
    .fsinfo:
        mov ax, 0x07c0
        mov ds, ax
        mov ax, 0x0800
        mov es, ax
        mov si, 0
        mov di, fsinfo
        .fsinfo.loop:
            mov al, [ds:si]
            mov [es:di], al
            inc si
            inc di
            cmp si, 0x0040
            jge .fsinfo.done
            jmp .fsinfo.loop
        .fsinfo.done:
    .segments:
        mov ax, 0x0800
        mov ds, ax
        mov es, ax

hang:
    cli
    hlt

bootmsg:
    .version: db 'MicroSYS Version 0.10 (Build 1381)$'

filenames:
    .config: dw __utf16__('CONFIG      SYS$')
    .kernel: dw __utf16__('SYSKERNEL   SYS$')
    .shell: dw __utf16__('SHELL       EXE$')
    .drivers: dw __utf16__('DRIVERS$')
    .microsys: dw __utf16__('MICROSYS$')

lbatochs:
    pusha
    .sec:
        mov bx, [fsinfo+0x0c]
        mov dx, 0
        div bx
        inc dx
        mov [.s], dl
    .cyl:
        mov bx, [fsinfo+0x0e]
        mov dx, 0
        div bx
        mov [.c], al
    .head:
        mov [.h], dl
    .done:
        popa
        mov ch, [.c]
        shl ch, 2
        mov cl, [.s]
        mov dh, [.h]
        ret
    .c: db 0
    .h: db 0
    .s: db 0

fsinfo: times 0x40 db 0

times 8192-($-$$) db 0