org 0x0000
bits 16
cpu 286

jmp near setup

sysfs_signature: db 0x29
sysfs_bytespersec: dw 512
sysfs_secsperblock: db 2
sysfs_bootblock: db 2
sysfs_secsinvolume: dw 2880
sysfs_blocksperdir: db 6
sysfs_secsperbet: db 12
sysfs_secspertrack: dw 18
sysfs_numofheads: dw 2
sysfs_secsbeforefs: dd 0
sysfs_int13: db 0
sysfs_drivetype: db 0xf4
sysfs_serial: db 'MSYS'
sysfs_betroot: dw 1
sysfs_bytesperbet: db 3
sysfs_reserved: times 3 db 0
sysfs_volumelabel:
    .label: dw __utf16__('MICROSYS 0.10   ')

setup:
    .segments:
        mov ax, 0x07c0
        mov ds, ax
        mov es, ax
        mov ax, 0x0c00
        mov ss, ax
    .bootdisk:
        mov [ds:bootdisk], dl
    .rstdisks:
        mov ax, 0
        int 0x13
    .stack:
        mov bp, 0
        mov sp, bp
    .video:
        mov ax, 2
        int 0x10
    .message:
        mov si, startmsg
        call printstr

hang:
    cli
    hlt

filename: db __utf16__('SYSBOOT     SYS$')
bootdisk: db 0

%include 'include/boot.inc'

lbatochs:
    pusha
    .sec:
        mov bx, [sysfs_secspertrack]
        mov dx, 0
        div bx
        inc dx
        mov [.s], dl
    .cyl:
        mov bx, [sysfs_numofheads]
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

startmsg: db 13, 10, '$'

times 510-($-$$) db 0
dw 0xaa55

times 1024-($-$$) db 0