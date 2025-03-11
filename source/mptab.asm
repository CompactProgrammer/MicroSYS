tabentry0:
    .length: db 10
    .attrlen: db 0
    .extloc: dd 0x17000000 ; 23
    .parentdir: dw 0
    .name: dw 0

times 4096-($-$$) db 0