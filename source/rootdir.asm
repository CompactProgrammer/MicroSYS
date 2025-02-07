entry0:
    .entrysize: db 48
    .filename: dw __utf16__('SYSBOOT    ')
    .ext: db 'SYS '
    .flags: db 0b00100101
    .ctime: dw 0
    .cdate: dw 0
    .mtime: dw 0
    .mdate: dw 0
    .cyear: db 0
    .myear: db 0
    .sizelow: dw 8192
    .firstbet: dw 0
    .sizemiddle: dw 0
    .sizehigh: dw 0
    .reserved: dw 0
entry1:
    .entrysize: db 48
    .filename: dw __utf16__('SYSKERNEL  ')
    .ext: db 'SYS '
    .flags: db 0b00100101
    .ctime: dw 0
    .cdate: dw 0
    .mtime: dw 0
    .mdate: dw 0
    .cyear: db 0
    .myear: db 0
    .sizelow: dw 8192
    .firstbet: dw 0
    .sizemiddle: dw 0
    .sizehigh: dw 0
    .reserved: dw 0

times 6144-($-$$) db 0