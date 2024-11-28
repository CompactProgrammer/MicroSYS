entry0:
    .name: db 'SYSBOOT    '
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
entry1:
    .name: db 'SYSKNL     '
    .ext: db 'BIN'
    .flags: db 0b00000000
    .cyear: db 0
    .ctime: dw 0
    .cdate: dw 0
    .mdate: dw 0
    .myear: db 0
    .res: db 0
    .firstblock: dw 4
    .lastblock: dw 11
    .size: dd 8192

times 3072-($-$$) db 0