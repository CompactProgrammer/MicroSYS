org 0x0000
bits 16
cpu 186

header:
    .signature: dw 0xd146
    .next: dw 0x0000
    .flags: db 0b00001101
    .drives: db 0
    .load: dw loadroutine
    .exec: dw execroutine
    .segment: dw 0x0000
    .reserved: dd 0
    .id: db 'KEYBRD  '

loadroutine:

execroutine:

times 2048-($-$$) db 0