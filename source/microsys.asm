org 0x0000
bits 16
cpu 186

jmp setup

%include 'include/video.inc'

setup:
    .segments:
        mov ax, 0
        mov ds, ax
        mov es, ax
    .video:
        mov ax, 2
        int 0x10
        call cls

main:
    mov si, welcomemsg
    call printstr

hang:
    cli
    hlt

welcomemsg: db 'MicroSYS$'

; --------------------------------
; |      Interrupt Handlers      |
; --------------------------------

int21handler:
    pusha
    cmp ah, 0
    je functerminate
    cmp ah, 1
    je funcintvector
    cmp ah, 2
    je funcversion
    popa
    mov ah, 1
    iret

functerminate:
    popa
    iret
funcintvector:
    popa
    iret
funcversion:
    popa
    iret

times 8192-($-$$) db 0