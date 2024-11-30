org 0x0000
bits 16
cpu 186

jmp near setup

vis_signature: db 'FS'
vis_bytespersec: dw 512
vis_secsperblock: db 2
vis_disktype: db 0xf4
vis_secsinvol: dw 2880
vis_secspertrack: dw 18
vis_numofheads: dw 2
vis_secsrootfolder: db 6
vis_volumeid: db 'MSYS'
vis_reserved: dd 0
vis_vollabel: db 'MICROSYS    '

setup:
    .segments:
        mov ax, 0x07c0
        mov ds, ax
        mov es, ax
        mov ax, 0x0700
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

mov si, 5
getrootfolder:
    dec si
    mov ah, 2
    mov al, [vis_secsrootfolder]
    inc al
    mov ch, 0
    mov cl, 3
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x400
    int 0x13
    jnc getbootldrloc
    cmp si, 0
    jne getrootfolder
    jmp booterror
getbootldrloc:
    mov cl, 80
    mov si, 0x400
    mov di, filename
    .loop:
        dec cl
        call cmpfn
        jnc .found
        cmp cl, 0
        je booterror
        add si, 32
        jmp .loop
    .found:
        add si, 0x18
        mov ax, [ds:si]
getchs:
    mov bx, 0
    mov bl, [vis_secsrootfolder]
    add ax, bx
    add ax, 2
    call lbatochs
    xchg bx, bx
readandexec:
    push ax
    mov ax, 0
    mov es, ax
    pop ax
    mov dh, 16
    mov dl, [ds:bootdisk]
    mov bx, 0x1000
    call readsectors
    jc .error
    .exec:
        xchg bx, bx
        jmp 0x0100:0
    .error:
        cmp si, 0
        je booterror
        jmp readandexec

hang:
    cli
    hlt

filename: db 'MICROSYS   SYS$'
hexbuffer: db 'FFFF$'
bootdisk: db 0

%include 'include/boot.inc'

lbatochs:
    pusha
    .sec:
        mov bx, [vis_secspertrack]
        mov dx, 0
        div bx
        inc dx
        mov [.s], dl
    .cyl:
        mov bx, [vis_numofheads]
        mov dx, 0
        div bx
        mov [.c], al
    .head:
        mov [.h], dl
    .done:
        popa
        mov ch, [.c]
        mov cl, [.s]
        mov dh, [.h]
        ret
    .c: db 0
    .h: db 0
    .s: db 0

times 510-($-$$) db 0
dw 0xaa55

times 1024-($-$$) db 0