tabentry0:
    .namelen: db 2
    .attrlen: db 0
    .extloc: dd 24
    .parentdir: dw 1
    .name: db 0
    .padding: db 0
tabentry1:
    .namelen: db 8
    .attrlen: db 0
    .extloc: dd 30
    .parentdir: dw 1
    .name: db 'MICROSYS'

times 4096-($-$$) db 0