org 0x1000
bits 16
cpu 186

jmp main

main:

hang:
    cli
    hlt

times 8192-($-$$) db 0