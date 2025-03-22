%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

tabentry0:
    .namelen: db 1
    .attrlen: db 0
    .extloc: dd swap_dword(24)
    .parentdir: dw 1
    .name: db 0
    .padding: db 0
tabentry1:
    .namelen: db 8
    .attrlen: db 0
    .extloc: dd swap_dword(25)
    .parentdir: dw 1
    .name: db 'MICROSYS'

times 4096-($-$$) db 0