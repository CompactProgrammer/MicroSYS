org 0x7c00
bits 16
cpu 186

setup:
    .bootdisk:
        mov [bootdisk], dl
    .segments:
        mov ax, 0
        mov ds, ax
        mov es, ax
        mov ss, ax
    .stack:
        mov bp, 0x8000
        mov sp, bp
    .video:
        mov ax, 2
        int 0x10

mov si, 5
loadbootblock:
    dec si
    mov ah, 2
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x7e00
    int 0x13
    jnc 0x7e00
    cmp si, 0
    je booterror
    jmp loadbootblock

nobootldrmsg: db 'Bootloader not found$'
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
    mov cx, 0x4000
    .loop:
        dec cx
        cmp cx, 0
        jne .loop
        jmp 0xffff:0

times 512-($-$$) db 0
dw 0xaa55

print:
    mov si, vis_vollabel
    call printstr

findrootdir:
    mov ax, [vis_secsineft]
    add ax, 3
convert:
    call lbatochs
    mov si, 5
loadrootdir:
    dec si
    mov ah, 2
    mov al, 1
    mov dl, [bootdisk]
    mov bx, 0x8200
    int 0x13
    jnc readfirstentry
    cmp si, 0
    je booterror
    jmp loadrootdir
readfirstentry:
    mov si, 0x8200
    mov al, [si]
    cmp al, 1
    jne booterror
    add si, 0x1a
    mov ax, [si]
    push ax
    mov si, 5
loadeft:
    dec si
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x8200
    int 0x13
    jnc getentry
    cmp si, 0
    je booterror
    jmp loadeft
getentry:
    mov si, 0x8200
    pop ax
    add si, ax
    mov ax, [si]
getlba:
    mov bx, 0
    mov bl, [vis_secsperblock]
    mul bx
    add ax, 3
    mov bx, [vis_secsineft]
    add ax, bx
    mov bx, [vis_secsrootfolder]
    add ax, bx
loopload:
    inc ax
convert2:
    call lbatochs
    mov si, 5
loadfile:
    dec si
    mov ah, 2
    mov al, 8
    mov dl, [bootdisk]
    mov bx, 0x7000
    int 0x13
    jnc 0x7000
    cmp si, 0
    je booterror
    jmp loopload

times 1024-($-$$) db 0

vis_signature: db 'FS'
vis_bytespersec: dw 512
vis_secsperblock: db 2
vis_disktype: db 0xf7
vis_secsinvol: dw 2400
vis_secspertrack: dw 15
vis_numofheads: dw 2
vis_volumeid: db 'MSYS'
vis_secsrootfolder: dw 6
vis_secsineft: dw 8
vis_reserved: dd 0
vis_vollabel: db 'MICROSYS'
db '$'

lbatochs:
    pusha
    .sec:
        mov bx, [vis_secspertrack]
        div bx
        inc dx
        mov [.s], dl
    .cyl:
        mov bx, [vis_numofheads]
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

times 1536-($-$$) db 0