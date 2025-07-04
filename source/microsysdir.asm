%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

entry0:
    .length: db 34
    .attrlen: db 0
    .extloc: dd 34, swap_dword(34)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000010
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 1
    .name: db 0
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
    .extloc: dd 35, swap_dword(35)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000000
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 12
    .name: db 'CONFIG.SYS'
    .fileid: db 59, '1'
    .padding: db 0
entry3:
    .length: db 46
    .attrlen: db 0
    .extloc: dd 36, swap_dword(36)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000000
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 12
    .name: db 'KEYBRD.SYS'
    .fileid: db 59, '1'
    .padding: db 0
entry4:
    .length: db 48
    .attrlen: db 0
    .extloc: dd 37, swap_dword(37)
    .datlen: dd 2048, swap_dword(2048)
    .recdate: times 7 db 0
    .fileflags: db 0b00000000
    .unitssize: db 0
    .interleave: db 0
    .volseqnum: dw 1, swap_word(1)
    .namelen: db 14
    .name: db 'CMDPRMPT.APP'
    .fileid: db 59, '1'
    .padding: db 0

times (2048*1)-($-$$) db 0