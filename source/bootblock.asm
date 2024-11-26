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

nobootldrmsg: db 'Boot error, press a key to reboot', 13, 10, '$'
bootdisk: db 0

printstr:
    pusha
    mov ah, 0x0e
    .loop:
        mov al, [ds:si]
        cmp al, '$'
        je .done
        int 0x10
        inc si
        jmp .loop
    .done:
        popa
        ret

booterror:
    .segment:
        mov ax, 0
        mov ds, ax
        mov es, ax
    .print:
        mov si, nobootldrmsg
        call printstr
    .wait:
        mov ax, 0
        int 0x16
        int 0x19

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

cmpfn:
    clc
    pusha
    .loop:
        mov ah, [ds:si]
        mov al, [es:di]
        cmp ah, '$'
        jmp .done
        cmp al, '$'
        jmp .done
        cmp ah, al
        jne .noequ
        inc si
        inc di
        jmp .loop
    .noequ:
        stc
    .done:
        popa
        ret

printfn:
    pusha
    mov ah, 0x0e
    mov cl, 14
    .loop:
        dec cl
        mov al, [ds:si]
        int 0x10
        cmp cl, 0
        je .done
        inc si
        jmp .loop
    .done:
        popa
        ret

; INPUT
; al    nibble to convert (low 4 bits)
; si    pointer to buffer
; OUTPUT
; si    pointer to hex string
nibbletohexstr:
    pusha
    .setup:
        mov di, .hexdigits
    .convert:
        and ax, 0x000f
        add di, ax
        mov al, [di]
        mov [si], al
    .done:
        popa
        ret
    .hexdigits: db '0123456789ABCDEF'

; INPUT
; al    byte to convert
; si    pointer to buffer
; OUTPUT
; si    pointer to hex string
bytetohexstr:
    pusha
    .convert:
        push ax
        and al, 0xf0
        shr al, 1
        shr al, 1
        shr al, 1
        shr al, 1
        call nibbletohexstr
        inc si
        pop ax
        call nibbletohexstr
    .done:
        popa
        ret
    
; INPUT
; ax    word to convert
; si    pointer to buffer
; OUTPUT
; si    pointer to hex string
wordtohexstr:
    pusha
    .convert:
        add si, 2
        call bytetohexstr
        sub si, 2
        mov al, ah
        call bytetohexstr
    .done:
        popa
        ret

times 510-($-$$) db 0
dw 0xaa55

mov si, 5
getrootfolder:
    dec si
    mov ah, 2
    mov al, [vis_secsrootfolder]
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
    mov si, 5
readandexec:
    dec si
    mov ax, 0x07c0
    mov ds, ax
    mov ax, 0
    mov es, ax
    mov ah, 2
    mov al, 8
    mov dl, [ds:bootdisk]
    mov bx, 0x6000
    int 0x13
    jc .error
    .exec:
        jmp 0x0600:0
    .error:
        cmp si, 0
        je booterror
        jmp readandexec

hang:
    cli
    hlt

filename: db 'MICROSYS   BIN$'
hexbuffer: db 'FFFF$'

times 1024-($-$$) db 0