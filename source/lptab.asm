pathtableentry0:
    .length: db 0
    .attrlen: db 0
    .extloc: dd 0
    .parentdir: dw 0
    .name: db 'ROOT    '

times 4096-($-$$) db 0