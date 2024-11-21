org 0x0000
bits 16
cpu 186

setup:
    .segments:
        mov ax, 0x07c0
        mov ds, ax
        mov es, ax
        mov ax, 0x0900
        mov ss, ax
    .bootdisk:
        mov [bootdisk], dl
    .stack:
        mov bp, 0
        mov sp, bp
    .video:
        mov ax, 2
        int 0x10

mov si, 5
loadbootblock:
    dec si
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x200
    int 0x13
    jnc 0x200
    cmp si, 0
    je booterror
    jmp loadbootblock

nobootldrmsg: db 'Boot error, press a key to reboot$'
bootdisk: db 0

printstr:
    pusha
    mov ah, 0x0e
    .loop:
        mov al, [si]
        cmp al, '$'
        je .done
        int 0x10
        inc si
        jmp .loop
    .done:
        popa
        ret

booterror:
    mov si, nobootldrmsg
    call printstr
    mov ax, 0
    int 0x16
    jmp 0xffff:0

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
        mov [.c], ax
    .head:
        mov [.h], dx
    .done:
        popa
        mov ch, [.c+1]
        mov cl, [.s+1]
        mov dh, [.h+1]
        ret
    .c: dw 0
    .h: dw 0
    .s: dw 0

times 510-($-$$) db 0
dw 0xaa55

mov si, 5
getrootfolder:
    dec si
    mov ax, [vis_secsrootfolder]
    mov ah, 2
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
    mov cl, 100
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
    add ax, [vis_secsrootfolder]
    add ax, 2
    call lbatochs
segment:
    mov ax, 0
    mov es, ax
    mov si, 5
readandexec:
    mov ah, 2
    mov al, 8
    mov dl, [bootdisk]
    mov bx, 0x7000
    int 0x10
    jc .error
    jmp 0x0700:0
    .error:
        cmp si, 0
        je booterror
        jmp readandexec

hang:
    cli
    hlt

filename: db 'BOOTLDR    BIN'

cmpfn:
    clc
    pusha
    mov cl, 14
    .loop:
        dec cl
        mov ah, [si]
        mov al, [di]
        cmp ah, al
        jne .noequ
        cmp cl, 0
        jmp .done
        inc si
        inc di
        jmp .loop
    .noequ:
        stc
    .done:
        popa
        ret

times 992-($-$$) db 0

vis_signature: db 'FS'
vis_bytespersec: dw 512
vis_secsperblock: db 2
vis_disktype: db 0xf4
vis_secsinvol: dw 2880
vis_secspertrack: dw 18
vis_numofheads: dw 2
vis_volumeid: db 'MSYS'
vis_secsrootfolder: dw 6
vis_reserved: dw 0
vis_vollabel: db 'MICROSYS    '

times 1024-($-$$) db 0