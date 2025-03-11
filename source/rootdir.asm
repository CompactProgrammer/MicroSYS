entry0:
    .length: db 44
    .attrlen: db 0
    .extloc0: dd 0
    .extloc1: dd 0
    .datlen0: dd 0x00002000 ; 8192
    .datlen1: dd 0x00000020
    .recdate: times 7 db 0
    .fileflags: db 0b00000000
    .unitssize: db 0
    .interleave: db 0
    .volseqnum0: dw 0x0001 ; 1
    .volseqnum1: dw 0x0100
    .namelen: db 1
    .name: db 'BOOT.SYS'
    .fileid: db 59, '1'
    .padding: db 0

times (2048*1)-($-$$) db 0