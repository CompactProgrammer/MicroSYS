entry0:
    .name: db 'IO         '
    .ext: db 'SYS'
    .flags: db 0b00000101
    .cyear: db 0
    .ctime: dw 0
    .cdate: dw 0
    .mdate: dw 0
    .myear: db 0
    .res: db 0
    .firstblock: dw 0
    .lastblock: dw 7
    .size: dd 4096
entry1:
    .name: db 'MICROSYS   '
    .ext: db 'SYS'
    .flags: db 0b00000101
    .cyear: db 0
    .ctime: dw 0
    .cdate: dw 0
    .mdate: dw 0
    .myear: db 0
    .res: db 0
    .firstblock: dw 8
    .lastblock: dw 23
    .size: dd 8192

times 3072-($-$$) db 0