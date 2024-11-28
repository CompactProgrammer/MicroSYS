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

newline:
    pusha
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
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

nobootldrmsg: db 'Boot error, press a key to reboot', 13, 10, '$'

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