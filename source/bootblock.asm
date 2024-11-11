org 0x7c00
bits 16

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

loadbootblock:
    mov ah, 2
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x7e00
    int 0x13
    jc loadbootblock
    jmp 0x7e00

nobootldrmsg: db 'BOOTLDR.BIN not found$'
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

times 512-($-$$) db 0
dw 0xaa55

findrootdir:
    mov ax, [vis_secsineft]
    add ax, 3
convert:
    call lbatochs
loadrootdir:
    mov ah, 2
    mov al, 1
    mov dl, [bootdisk]
    mov bx, 0x8200
    int 0x13
    jc loadrootdir
readfirstentry:
    mov si, 0x8200
    mov al, [si]
    cmp al, 1
    jne booterror
    add si, 0x1a
    mov ax, [si]
    push ax
loadeft:
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x8200
    int 0x13
    jc loadeft
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
    mov si, 4
loopload:
    inc ax
convert2:
    call lbatochs
loadfile:
    dec si
    mov ah, 2
    mov al, 1
    mov dl, [bootdisk]
    mov bx, 0x7000
    int 0x13
    jc loadfile
    cmp si, 0
    je 0x7000
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

lbatochs:

times 1536-($-$$) db 0