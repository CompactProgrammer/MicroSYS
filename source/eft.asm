entry0:
    first: dw 0
    last: dw 3
    next: dw 0xffff
    type: db 1
    res: db 0

times 4096-($-$$) db 0