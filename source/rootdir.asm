entry0:
    .type: db 1
    .name: db 'BOOTLDR   '
    .ext: db 'BIN'
    .flags: db 0b00000000
    .cyear: db 0
    .ctime: dw 0
    .cdate: dw 0
    .mdate: dw 0
    .res: dd 0
    .eft: dw 0
    .size: dd 4096

times 3072-($-$$) db 0