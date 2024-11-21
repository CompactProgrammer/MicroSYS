org 0x0000
bits 16
cpu 186

setup:
    .segments:
        mov ax, 0x0700
        mov es, ax
        mov ds, ax
    .startmsg:
        mov si, startupmsg
        call printstr

halt:
    cli
    hlt

startupmsg: db 'Starting MicroSYS...$'

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

times 4096-($-$$) db 0