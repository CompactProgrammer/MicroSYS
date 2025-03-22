%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

entry0:
    .length: db 34
    .attrlen: db 0
    .extloc: dd 25, swap_dword(25)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000010
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 1
    .padding: db 0
entry1:
    .length: db 34
    .attrlen: db 0
    .extloc: dd 24, swap_dword(24)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000010
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 1
    .name: db 1
entry2:
    .length: db 46
    .attrlen: db 0
    .extloc: dd 27, swap_dword(27)
    .datlen: dd 4096, swap_dword(4096)
    .recdate: times 7 db 0
    .fileflags: db 0b00000000
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 12
    .name: db 'SYSLDR.SYS'
    .fileid: db 59, '1'
    .padding: db 0

times (2048*1)-($-$$) db 0