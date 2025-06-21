%define swap_word(x) (((x) >> 8) | ((x) << 8))
%define swap_dword(x) (((x) >> 24) | (((x) >> 8) & 0x0000FF00) | (((x) << 8) & 0x00FF0000) | ((x) << 24))

primarydesc:
    .type: db 1
    .id: db 'CD001'
    .version: db 1
    .unused0: db 0
    .sysid: db '                                '
    .volid: db 'MICROSYS                        '
    .unused1: times 8 db 0
    .volsize: dd 3072, swap_dword(3072) ; 6MB
    .unused2: times 32 db 0
    .volsetsize: dw 1, swap_word(1)
    .volseqnum: dw 1, swap_word(1)
    .blocksize: dw 2048, swap_word(2048)
    .pathsize: dd 4096, swap_dword(4096)
    .lpathtable: dd 20
    .loptpathtable: dd 0
    .mpathtable: dd swap_dword(22)
    .moptpathtable: dd swap_dword(0)
    .rootdir:
        .rootdir.length: db 34
        .rootdir.attrlen: db 0
        .rootdir.extloc: dd 24, swap_dword(24)
        .rootdir.datlen: dd 2048, swap_dword(2048)
        .rootdir.recdate: times 7 db 0
        .rootdir.fileflags: db 0b00000010
        .rootdir.unitssize: db 0
        .rootdir.interleave: db 0
        .rootdir.volseqnum: dw 1, swap_word(1)
        .rootdir.namelen: db 1
        .rootdir.name: db 0
    .volsetid:
        db 'MICROSYS'
        times 120 db ' '
    .pubid:
        db 'CompactProgrammer '
        times 110 db ' '
    .prepid:
        db 'CompactProgrammer '
        times 110 db ' '
    .appid:
        db 'CompactProgrammer '
        times 110 db ' '
    .copyright: times 37 db ' '
    .abstract: times 37 db ' '
    .biblio: times 37 db ' '
    .creation:
        times 16 db '0'
        db 0
    .modification:
        times 16 db '0'
        db 0
    .expiration:
        times 16 db '0'
        db 0
    .effective:
        times 16 db '0'
        db 0
    .filestructure: db 1
    .unused3: db 0
    .application:
        db 'MicroSYS version 0.10'
        times 491 db 0
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