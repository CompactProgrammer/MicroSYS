org 0
bits 16
cpu 186

jmp setup
db 'KERNEL'
%include 'include/video.inc'

redrawtop:
    pusha
    mov ax, es
    push ax
    mov ax, 0xb800
    mov es, ax
    .prep0:
        mov cx, 0
        mov si, toptext
        mov di, 0
    .loop0:
        inc cx
        cmp cx, 81
        je .done
        mov al, [ds:si]
        mov [es:di], al
        inc di
        mov al, 0b01110000
        mov [es:di], al
        inc di
        inc si
        jmp .loop0
    .done:
        pop ax
        mov es, ax
        popa
        ret

setup:
    .segments:
        mov ax, 0x0100
        mov ds, ax
        mov ax, 0x0800
        mov es, ax
    .bootdisk:
        mov [ds:bootdisk], dl
    .topbar:
        call cls
        call redrawtop

main:

hang:
    cli
    hlt

bootdisk: db 0
toptext:
    .0: db 'MicroSYS Program Manager'
    .1: times 34 db 0
    .2: db 'Press ALT to show menu'

times 8192-($-$$) db 0