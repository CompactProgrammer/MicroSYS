%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

entry0:
    .length: db 34
    .attrlen: db 0
    .extloc0: dd 29
    .extloc1: dd swap_dword(29)
    .datlen0: dd 2048
    .datlen1: dd swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000010
    .unitssize: db 0
    .interleave: db 0
    .volseqnum0: dw 1
    .volseqnum1: dw swap_word(1)
    .namelen: db 1
    .padding: db 0
entry1:
    .length: db 36
    .attrlen: db 0
    .extloc0: dd 24
    .extloc1: dd swap_dword(24)
    .datlen0: dd 2048
    .datlen1: dd swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000010
    .unitssize: db 0
    .interleave: db 0
    .volseqnum0: dw 1
    .volseqnum1: dw swap_word(1)
    .namelen: db 2
    .name: db '..'
    .padding: db 0

times (2048*1)-($-$$) db 0