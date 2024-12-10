entry0_file:
    .ext: db 'SYS '
    .flags: dw 0b0000000000001101
    .ctime: dw 0
    .cdate: dw 0
    .mtime: dw 0
    .mdate: dw 0
    .cyear: db 0
    .myear: db 0
    .sizelow: dw 8192
    .firstbet: dw 4
    .sizemiddle: dw 0
    .fnentry: dw 1
    .sizehigh: dw 0
    .entrysize: db 32
    .reserved: times 5 db 0
entry0_name:
    .nextentry: dw 0xffff
    .order: dw 0
    .flags: dw 0b0000000000100000
    .filename0: dw __utf16__('SYSBOOT   ')
    .sizeentry: db 32
    .reserved: db 0
    .filename1: dw __utf16__('  ')
entry1_file:
    .ext: db '    '
    .flags: dw 0b0000000000011101
    .ctime: dw 0
    .cdate: dw 0
    .mtime: dw 0
    .mdate: dw 0
    .cyear: db 0
    .myear: db 0
    .sizelow: dw 4096
    .firstbet: dw 20
    .sizemiddle: dw 0
    .fnentry: dw 3
    .sizehigh: dw 0
    .entrysize: db 32
    .reserved: times 5 db 0
entry1_name:
    .nextentry: dw 0xffff
    .order: dw 0
    .flags: dw 0b0000000000100000
    .filename0: dw __utf16__('MICROSYS  ')
    .sizeentry: db 32
    .reserved: db 0
    .filename1: dw __utf16__('  ')

times 4096-($-$$) db 0