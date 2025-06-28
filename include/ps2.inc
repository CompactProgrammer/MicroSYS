ps2pollread:
    pusha
    .loop:
        in al, 0x64
        test al, 0b00000001
        jz .loop
    .done:
        popa
        ret

ps2pollwrite:
    pusha
    .loop:
        in al, 0x64
        test al, 0b00000010
        jnz .loop
    .done:
        popa
        ret

; INPUT
; al    command
ps2writecom:
    call ps2pollwrite
    out 0x64, al
    ret

; OUTPUT
; al    status byte
ps2getstatus:
    in al, 0x64
    ret

; OUTPUT
; al    data
ps2waitdata:
    call ps2pollread
    in al, 0x60
    ret

; OUTPUT
; al    data
; carry flag set if no data
ps2checkdata:
    clc
    pusha
    .check:
        in al, 0x64
        test al, 0b00000001
        jz .nodata
    .read:
        in al, 0x60
        mov [.output], al
        jmp .done
    .nodata:
        stc
        mov al, 0
        mov [.output], al
    .done:
        popa
        mov al, [.output]
        ret
    .output: db 0

; INPUT
; al    data
ps2writeport:
    clc
    pusha
    mov bl, 5
    .loop:
        dec bl
        call ps2pollwrite
        out 0x60, al
        call ps2waitdata
        cmp al, 0xfa
        je .done
        cmp bl, 0
        jne .loop
    .error:
        stc
    .done:
        popa
        ret

ps2disableports:
    pusha
    .disable:
        call ps2pollwrite
        mov al, 0xad
        call ps2writecom
        mov al, 0xa7
        call ps2writecom
    .done:
        popa
        ret

ps2enableports:
    pusha
    .enable:
        call ps2pollwrite
        mov al, 0xae
        call ps2writecom
    .done:
        popa
        ret

; OUTPUT
; al    config byte
ps2readconfig:
    .read:
        mov al, 0x20
        call ps2writecom
        call ps2waitdata
    .done:
        ret

; INPUT
; al    config byte
ps2writeconfig:
    .write:
        push ax
        mov al, 0x60
        call ps2writecom
        pop ax
        call ps2writecom
    .done:
        ret

; OUTPUT
; carry flag set if error
ps2test:
    clc
    pusha
    .getconfig:
        call ps2readconfig
        push ax
    .test:
        mov al, 0xaa
        call ps2writecom
        call ps2waitdata
        cmp al, 0x55
        jne .error
    .restore:
        pop ax
        call ps2writeconfig
    .testfirstport:
        mov al, 0xab
        call ps2writecom
        call ps2waitdata
        cmp al, 0
        jne .error
    .error:
        stc
    .done:
        popa
        ret

ps2disableints:
    pusha
    .disable:
        call ps2readconfig
        and al, 0b11111100
        call ps2writeconfig
    .done:
        popa
        ret

ps2enableints:
    pusha
    .enable:
        call ps2readconfig
        or al, 0b00000001
        call ps2writeconfig
    .done:
        popa
        ret

ps2disabletranslation:
    pusha
    .disable:
        call ps2readconfig
        and al, 0b10111111
        call ps2writeconfig
    .done:
        popa
        ret

ps2enabletranslation:
    pusha
    .enable:
        call ps2readconfig
        or al, 0b01000000
        call ps2writeconfig
    .done:
        popa
        ret

; OUTPUT
; carry flag set if error
ps2reset:
    clc
    pusha
    .reset:
        mov al, 0xff
        call ps2writeport
    .getid:
        call ps2waitdata
        cmp al, 0xaa
        je .done
    .error:
        stc
    .done:
        popa
        ret