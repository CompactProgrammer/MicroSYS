entry0:
    .name: db 'BOOTLDR    '
    .ext: db 'BIN'
    .flags: db 0b00000000
    .cyear: db 0
    .ctime: dw 0
    .cdate: dw 0
    .mdate: dw 0
    .myear: db 0
    .res: db 0
    .firstblock: dw 0
    .lastblock: dw 3
    .size: dd 4096

times 3072-($-$$) db 0