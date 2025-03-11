primarydesc:
    .type: db 1
    .id: db 'CD001'
    .version: db 1
    .unused0: db 0
    .sysid: db 'LINUX                           '
    .volid: db 'MicroSYS 0.10                   '
    .unused1: times 8 db 0
    .volsize0: dd 0x00001620 ; 5664
    .volsize1: dd 0x20160000
    .unused2: times 32 db 0
    .volsetsize0: dw 0x0001 ; 1
    .volsetsize1: dw 0x0100
    .volseqnum0: dw 0x0001 ; 1
    .volseqnum1: dw 0x0100
    .blocksize0: dw 0x0800 ; 2048
    .blocksize1: dw 0x0008
    .pathsize0: dw 0x1000 ; 4096
    .pathsize1: dw 0x0001
    .lpathtable: dd 0
    .loptpathtable: dd 0
    .mpathtable: dd 0
    .moptpathtable: dd 0
    .rootdir: times 34 db 0
    .volsetid: times 128 db 0
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
times (2048*2)-($-$$) db 0
terminate:
    .type: db 255
    .id: db 'CD001'
    .version: db 1
times (2048*3)-($-$$) db 0