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
sysfs_bytesperbet: db 4
sysfs_reserved: times 5 db 0
sysfs_volumelabel:
    .label: dw __utf16__('MICROSYS 0.10   ')

setup:
    .segments:
        mov ax, 0x07c0
        mov ds, ax
        mov es, ax
        mov ax, 0x0e00
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

loadbootblock:
    mov ax, 1
    mov dh, 1
    mov dl, [bootdisk]
    mov bx, 0x200
    call readsectors
    jnc bootblockstart

error:
    mov si, errormsg
    call printstr

hang:
    cli
    hlt

errormsg: db 'Boot error$'
bootdisk: db 0
hexword: db 'FFFF$'

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

bootblockstart:

segment0:
    mov ax, 0x0a00
    mov es, ax

getrootdir:
    mov ax, 0
    mov al, [ds:sysfs_bootblock]
    mov cx, 0
    mov cl, [ds:sysfs_secsperbet]
    add ax, cx
    push ax
    mov al, [ds:sysfs_blocksperdir]
    mov bl, [ds:sysfs_secsperblock]
    mul bl
    mov dh, al
    pop ax
    mov dl, [ds:bootdisk]
    mov bx, 0
    call readsectors
    jc error

getentry:
    mov si, filename
    mov di, 0
    mov cx, 512
    .loop:
        call cmpfn_utf16
        jnc .found
        mov ax, 0
        mov al, [es:si]
        add si, ax
        loop .loop
        jmp error
    .found:

getblock:
    add si, 0x28
    mov ax, [es:si]
    mov si, hexword
    call wordtohexstr
    call printstr

jmp hang

filename: db __utf16__('SYSBOOT     SYS$')

times 1024-($-$$) db 0