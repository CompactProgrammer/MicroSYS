org 0x0000
bits 16
cpu 186

header:
    .signature: db 0xde
    .length: db 20
    .flags: db 0b00001101
    .drives: db 0
    .load: dw loadroutine
    .exec: dw execroutine
    .segment: dw 0
    .memory: dw 0x0080
    .id: db 'KEYBRD  '

%include 'include/ps2.inc'

loadroutine:

execroutine:

cominit:

cominput:

comnowait:

comstatin:

comflushin:

comoutput:

comstatout:

comflushout:

times 2048-($-$$) db 0