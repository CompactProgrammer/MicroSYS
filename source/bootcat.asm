entry0:
    .valid:
        .valid.hid: db 1
        .valid.pid: db 0
        .valid.reserved: dw 0
        .valid.devid: db 'MicroSYS                '
        .valid.checksum: db 0
        .valid.signature: db 0x55, 0xaa
    .default:
        .default.indct: db 0x88
        .default.media: db 0
        .default.segment: dw 0x0100
        .default.systype: db 0
        .default.reserved: db 0
        .default.sectors: dw 16
        .default.rba: dd 0

times 2048-($-$$) db 0