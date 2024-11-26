org 0x0000
bits 16
cpu 186

jmp setup

setup:


; put function code in AX
; put parameters in stack
callfunc:
    .findfunc:

times 8192-($-$$) db 0