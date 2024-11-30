org 0x0000
bits 16
cpu 186

header:
    .initcode: dw setup
    .relocseg: dw 0

%include 'include/video.inc'
%include 'include/ps2.inc'

setup:

ps2setup:
    jmp .disable
    .error:
        mov si, .ps2initerr
        call printerror
        jmp hang
    .ps2initerr:
        db 'PS/2 port failed to initialize$'
    .disable:
        call ps2disableints
        call ps2disableports
    .flushbuffer:
        in al, 0x60
    .setconfig:
        call ps2readconfig
        and al, 0b00101100
        call ps2writeconfig
    .selftest:
        call ps2test
        jc .error
    .enable:
        call ps2enableports
        call ps2enableints
    .reset:
        call ps2reset
        jc .error

intsetup:
    .int16:
        mov ah, 1
        mov al, 0x16
        mov cx, [header.relocseg]
        mov dx, [int16handler]
        int 0x21

int16handler:
    pusha
    cmp ah, 0
    je .waitkey
    cmp ah, 1
    je .checkkey
    popa
    mov ah, 1
    iret
    .waitkey:
        call ps2disableints
        call ps2waitdata
        call ps2enableints
        popa
        mov ah, 0
        iret
    .checkkey:
        call ps2checkdata
        jnc checkkey.done
        .checkkey.nodata:
            popa
            mov ah, 0xff
            iret
        .checkkey.done:
            popa
            mov ah, 0
            iret

times 4096-($-$$) db 0