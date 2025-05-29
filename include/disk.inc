db 'DAP'
diskaddrpack:
    .size: db 0x10
    .unused: db 0
    .sectors: dw 1
    .offset: dw 0
    .segment: dw 0x0800
    .start0: dd 24
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
        push es
        pop ax
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