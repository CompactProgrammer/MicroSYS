sysboot:
    .0:
        db 0x01, 0x00 ; block descriptor, checksum of block
        dw 0x0001 ; next block in allocation chain
    .1:
        db 0x01, 0x00
        dw 0x0002
    .2:
        db 0x01, 0x00
        dw 0x0003
    .3:
        db 0x01, 0x00
        dw 0x0004
    .4:
        db 0x01, 0x00
        dw 0x0005
    .5:
        db 0x01, 0x00
        dw 0x0006
    .6:
        db 0x01, 0x00
        dw 0x0007
    .7:
        db 0x01, 0x00
        dw 0xffff

config:
    .0:
        db 0x01, 0x00
        dw 0xffff

times 6144-($-$$) db 0