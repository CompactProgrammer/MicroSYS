entry0:
    .valid:
        .valid.hid: db 1
        .valid.pid: db 0
        .valid.reserved: dw 0
        .valid.devid: db 'MicroSYS                '
        .valid.checksum: dw 0
        .valid.signature: db 0x55, 0xaa
    .default:
        .default.indct: db 0x88
        .default.media: db 0
        .default.segment: dw 0
        .default.systype: db 0
        .default.reserved0: db 0
        .default.sectors: dw 4
        .default.rba: dd 26
        .default.reserved1: times 20 db 0

times 2048-($-$$) db 0