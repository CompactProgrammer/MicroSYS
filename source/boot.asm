org 0x7c00
bits 16
cpu 386

jmp setup
%include 'include/boot.inc'

setup:
    .segments:
        mov ax, 0
        mov ds, ax
        mov es, ax
    .stack:
        mov ax, 0x0700
        mov ss, ax
        mov sp, 0
        mov bp, 0
    .bootdisk:
        mov [bootdisk], dl
    .serial:
        mov ah, 0
        mov al, 0b11100011
        mov dx, 0
        int 0x14
    .version:
        mov ax, 0
        mov es, ax
        mov ax, 16
        mov cx, 1
        mov dl, [bootdisk]
        mov bx, 0x8000
        call readsectors
        jc error
        call newline
        mov si, 0x8373
        call printstr
        mov si, startupmsg
        call printstr

main:
    .getrootdir:
        mov si, 0x80a6
        mov ax, [si]
        mov dx, 0
        mov bx, 2048
        div bx
        cmp dx, 0
        je .getrootdir.nocarry
        inc ax
        .getrootdir.nocarry:
        mov cx, ax
        mov si, 0x809e
        mov ax, [si]
        mov dl, [bootdisk]
        mov bx, 0
        mov es, bx
        mov bx, 0x8000
        call readsectors
        jc error
    .findfile:
        mov cx, 60
        mov si, knlfilename
        mov di, 0x8000
        .findfile.loop:
            dec cx
            add di, 33
            call cmpfn
            jnc .findfile.found
            cmp cx, 0
            je knlnotfound
            sub di, 33
            mov ah, 0
            mov al, [di]
            add di, ax
            jmp .findfile.loop
        .findfile.found:
            sub di, 23
            mov ax, [di]
            mov dx, 0
            mov bx, 2048
            div bx
            cmp dx, 0
            je .findfile.found.nocarry
            inc ax
            .findfile.found.nocarry:
            mov cx, ax
            sub di, 8
            mov ax, [di]
            mov dl, [bootdisk]
            mov bx, 0
            mov es, bx
            mov bx, 0x1000
            call readsectors
            jc error
    .callkernel:
        mov dl, [bootdisk]
        call 0x0100:0

loadconfigfile:

jmp hang

knlnotfound:
    mov si, knlnotfoundmsg
    call printstr
    jmp hang
outdatedbios:
    mov si, outdatedmsg
    call printstr
    jmp hang
error:
    mov si, booterrmsg
    call printstr
hang:
    cli
    hlt

bootdisk: db 0
knlfilename: db 'SYSKNL.SYS', 59, '1', 0

startupmsg: db 13, 10, 'Starting MicroSYS...', 0
outdatedmsg: db 13, 10, 'Outdated BIOS, MicroSYS will not run', 0
booterrmsg: db 13, 10, 'Boot error, reboot to try again', 0
knlnotfoundmsg: db 13, 10, 'Kernel not found, reboot to try again', 0

hexbytestr: times 3 db 0

times 2048-($-$$) db 0