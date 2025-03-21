%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

primarydesc:
    .type: db 1
    .id: db 'CD001'
    .version: db 1
    .unused0: db 0
    .sysid: db '                                '
    .volid: db 'MicroSYS 0.10                   '
    .unused1: times 8 db 0
    .volsize0: dd 3072
    .volsize1: dd swap_dword(3072) ; 6MB
    .unused2: times 32 db 0
    .volsetsize0: dw 1
    .volsetsize1: dw swap_word(1)
    .volseqnum0: dw 1
    .volseqnum1: dw swap_word(1)
    .blocksize0: dw 2048
    .blocksize1: dw swap_word(2048)
    .pathsize0: dw 4096
    .pathsize1: dw swap_word(4096)
    .lpathtable: dd 20
    .loptpathtable: dd 0
    .mpathtable: dd swap_dword(22)
    .moptpathtable: dd swap_dword(0)
    .rootdir:
        .rootdir.length: db 34
        .rootdir.attrlen: db 0
        .rootdir.extloc0: dd 24
        .rootdir.extloc1: dd swap_dword(24)
        .rootdir.datlen0: dd 2048
        .rootdir.datlen1: dd swap_dword(2048)
        .rootdir.recdate: times 7 db 0
        .rootdir.fileflags: db 0b00000010
        .rootdir.unitssize: db 0
        .rootdir.interleave: db 0
        .rootdir.volseqnum0: dw 1
        .rootdir.volseqnum1: dw swap_word(1)
        .rootdir.namelen: db 1
        .rootdir.padding: db 0
    .volsetid: times 128 db 0x20
    .pubid: times 128 db 0x20
    .prepid: times 128 db 0x20
    .appid: times 128 db 0x20
    .copyright: times 37 db 0x20
    .abstract: times 37 db 0x20
    .biblio: times 37 db 0x20
    .creation: times 17 db 0
    .modification: times 17 db 0
    .expiration: times 17 db 0
    .effective: times 17 db 0
    .filestructure: db 1
    .unused3: db 0
    .application: times 512 db 0
times (2048*1)-($-$$) db 0
bootrecord:
    .type: db 0
    .id: db 'CD001'
    .version: db 1
    .systid: db 'EL TORITO SPECIFICATION         '
    .bootid: times 32 db 0
    .bootcat: dd 19
times (2048*2)-($-$$) db 0
terminate:
    .type: db 255
    .id: db 'CD001'
    .version: db 1
times (2048*3)-($-$$) db 0