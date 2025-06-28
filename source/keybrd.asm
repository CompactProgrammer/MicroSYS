org 0x0000
bits 16
cpu 186

header:
    .sign: db 0xde
    .length: db 20
    .flags: db 0b00000000
    .drives: db 0
    .load: dw loadroutine
    .exec: dw execroutine
    .segment: dw 0
    .memory: dw 0x0080
    .id: db 'KEYBRD  '

%include 'include/ps2.inc'

loadroutine:
    mov ax, ds
    mov [cs:headpoint.seg], ax
    mov [cs:headpoint.off], si
    inc si
    mov [cs:headpoint.com], si
    add si, 2
    mov [cs:headpoint.paramoff], si
    ret

execroutine:
    mov ax, [cs:headpoint.com]
    cmp ax, 0x0000
    je cominit
    cmp ax, 0x0004
    je cominput
    cmp ax, 0x0005
    je comnowait
    cmp ax, 0x0006
    je comstatin
    cmp ax, 0x0007
    je comflushin
    cmp ax, 0x0008
    je comoutput
    cmp ax, 0x000a
    je comstatout
    cmp ax, 0x000b
    je comflushout
    mov ah, 0x02
return:
    push ax
    mov ax, [cs:headpoint.seg]
    mov ds, ax
    mov si, [cs:headpoint.off]
    pop ax
    add si, 0x0c
    mov [ds:si], ax
    retf

headpoint:
    .seg: dw 0
    .off: dw 0
    .com: dw 0
    .paramoff: dw 0

cominit:
    .retdata:
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        dec si
        mov al, 0
        mov [ds:si], al
    .disableports:
        call ps2disableports
    .flush:
        call ps2checkdata
    .disable:
        call ps2disableints
        call ps2disabletranslation
    .test:
        call ps2test
        jc .error
    .enable:
        call ps2enableints
        call ps2enabletranslation
        call ps2enableports
    .reset:
        call ps2reset
        jc .error
    .done:
        mov ah, 0
        jmp return
    .error:
        mov ah, 9
        jmp return

cominput:
    .input:
        call ps2waitdata
    .retdata:
        push ax
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        pop ax
        mov [ds:si], al
        dec si
        mov al, 1
        mov [ds:si], al
    .done:
        mov ah, 0
        jmp return

comnowait:
    .input:
        call ps2checkdata
        jc .error
    .retdata:
        push ax
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        pop ax
        mov [ds:si], al
        dec si
        mov al, 1
        mov [ds:si], al
    .done:
        mov ah, 0
        jmp return
    .error:
        mov ah, 5
        jmp return

comstatin:
    .getstat:
        call ps2getstatus
    .readycheck:
        test al, 0b00000001
        jz .notready
    .retdata:
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        dec si
        mov al, 0
        mov [ds:si], al
    .done:
        mov ah, 0
        jmp return
    .notready:
        mov ah, 5
        jmp return

comflushin:
    .input:
        call ps2checkdata
    .retdata:
        push ax
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        pop ax
        mov [ds:si], al
        dec si
        mov al, 1
        mov [ds:si], al
    .done:
        mov ah, 0
        jmp return

comoutput:
    .retdata:
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        dec si
        mov al, 0
        mov [ds:si], al
    .output:
        inc si
        mov al, [ds:si]
        call ps2writeport
    .done:
        mov ah, 0
        jmp return
    .error:
        mov ah, 7
        jmp return

comstatout:
    .getstat:
        call ps2getstatus
    .readycheck:
        test al, 0b00000010
        jz .notready
    .retdata:
        mov ax, [cs:headpoint.seg]
        mov ds, ax
        mov si, [cs:headpoint.paramoff]
        dec si
        mov al, 0
        mov [ds:si], al
    .done:
        mov ah, 0
        jmp return
    .notready:
        mov ah, 6
        jmp return

comflushout:
    .wait:
        call ps2pollwrite
    .done:
        mov ah, 0
        jmp return

times 2048-($-$$) db 0