org 0x0000
bits 16
cpu 186

jmp setup

%include 'include/boot.inc'
%include 'include/bootextra.inc'

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

bootdelay:
    mov si, bootmsg
    call printstr
    mov ah, 0x86
    mov cx, 0x000f
    mov dx, 0x4240
    int 0x15
    call newline
    mov ah, 0x86
    mov cx, 0x0007
    mov dx, 0xa120
    int 0x15
    call newline

initdevices:
    .serial:
        mov si, bootmsg.serialinit
        call printstr
        mov ah, 0x00
        mov al, 0b11100011
        mov dx, 0
        int 0x14
        mov si, serialmsg.init
        call serialoutstr
        call newline
    .getconfig:
        mov si, bootmsg.config
        call printstr
        call loadconfig
        call newline
    .loadkernel:
        mov si, bootmsg.kernel
        call printstr
        call loadkernel
        call newline

hang:
    cli
    hlt

bootmsg:
    .version: db 'MicroSYS Version 0.10 (Build 0x0001)$'
    .serialinit: db 'Initializing serial ports...$'
    .config: db 'Processing CONFIG.SYS...$'
    .kernel: db 'Loading kernel...$'

serialmsg:
    .init: db 13, 10, '[INFO] Serial port initialized$', 13, 10

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

fsinfo: times 0x64 db 0

times 8192-($-$$) db 0