printchar:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret

printstr:
    pusha
    mov ah, 0x0e
    .loop:
        mov al, [ds:si]
        cmp al, 0
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

; INPUT
; si    pointer to filename 1
; di    pointer to filename 2
cmpfn:
    clc
    pusha
    .loop:
        mov ah, [si]
        mov al, [di]
        cmp ah, 0
        je .done
        cmp ah, al
        jne .notfound
        inc si
        inc di
        jmp .loop
    .notfound:
        stc
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

serialoutchar:
    clc
    pusha
    mov dx, 0
    mov ah, 1
    int 0x14
    test ah, 0x80
    jz .done
    .error:
        stc
    .done:
        popa
        ret

serialoutstr:
    clc
    pusha
    mov dx, 0
    .loop:
        mov ah, 1
        mov al, [ds:si]
        cmp al, 0
        je .done
        int 0x14
        test ah, 0x80
        jnz .error
        inc si
        jmp .loop
    .error:
        stc
    .done:
        popa
        ret

db 'DAP'
diskaddrpack:
    .size: db 0x10
    .unused: db 0
    .sectors: dw 1
    .offset: dw 0x8000
    .segment: dw 0
    .start0: dd 16
    .start1: dd 0

; INPUT
; ax    start sector
; cx    number of sectors
; dl    drive number
; es:bx pointer to buffer
readsectors:
    clc
    pusha
    .dap:
        mov di, diskaddrpack.sectors
        mov [di], cx
        add di, 2
        mov [di], bx
        add di, 2
        push ax
        mov ax, es
        mov [di], ax
        pop ax
        add di, 2
        mov [di], ax
        add di, 2
        mov word[di], 0
        add di, 2
        mov word[di], 0
        add di, 2
        mov word[di], 0
    .read:
        mov ah, 0x42
        mov si, diskaddrpack
        int 0x13
        jnc .done
    .error:
        stc
    .done:
        popa
        ret