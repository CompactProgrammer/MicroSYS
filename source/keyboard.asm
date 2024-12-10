org 0x0000
bits 16
cpu 186

header:
    .type: db 0
    .maincode: dw main
    .cs: dw 0
    .ds: dw 0
    .devices: db 1
    .attrib: db 0b00001010
    .name: db 'PS2KEYB'
    .datrequired: db 0

%include 'include/ps2.inc'

main:
    clc
    pusha
    mov ah, 0
    .getfunc:
        add si, 2
        mov al, [es:si]
        sub si, 2
    .func:
        cmp al, 0
        je init
        cmp al, 1
        je read
        cmp al, 4
        je check
        cmp al, 5
        je status
        popa
        mov ah, 1
        stc
        retf

init:
    jmp .disable
    .error:
        mov al, 0x0a
        mov [.error], al
        jmp .updateheader
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
    .loadintvector:
        mov dx, es
        mov ax, 0
        mov es, ax
        mov di, 0x24
        mov ax, [header.maincode]
        mov [es:di], ax
        add di, 2
        mov ax, [header.cs]
        mov [es:di], ax
    .prepheader:
        mov al, 0
        mov [.error], al
    .updateheader:
        mov al, 8 ; header len
        mov [es:si], al
        inc si
        mov al, 0 ; data len
        mov [es:si], al
        add si, 2 ; error code
        mov al, [.error]
        mov [es:si], al
    .done:
        popa
        retf

; OUTPUT
; al    data
read:
    .wait:
        mov al, [keyavailable]
        cmp al, 0
        je .wait
        mov al, [keybuffer]
    .waitdone:
        mov [.output], al
    .updateheader:
        mov al, 8 ; header len
        mov [es:si], al
        inc si
        mov al, 1 ; data len
        mov [es:si], al
        add si, 2 ; error code
        mov al, 0
        mov [es:si], al
        add si, 5 ; data contents
        mov al, [.output]
        mov [es:si], al
    .done:
        popa
        retf
    .output: db 0

check:
    .check:
        mov al, [keyavailable]
        cmp al, 0
        je .nodata
        mov al, [keybuffer]
        mov [.output], al
        mov al, 0
        mov [.error], al
        mov [keyavailable], al
        jmp .updateheader
    .nodata:
        mov al, 0x0b
        mov [.error], al
    .updateheader:
        mov al, 8 ; header len
        mov [es:si], al
        inc si
        mov al, 1 ; data len
        mov [es:si], al
        add si, 2 ; error code
        mov al, [.error]
        mov [es:si], al
        add si, 5 ; data contents
        mov al, [.output]
        mov [es:si], al
    .done:
        popa
        retf
    .error: db 0
    .output: db 0

status:
    .readport:
        in al, 0x64
        mov ah, al
        mov al, 0
    .outbuffer0:
        test ah, 0b00000001
        jz .outbuffer1
        or al, 0b00000001
    .outbuffer1:    
        mov ah, [keyavailable]
        cmp ah, 0
        je .outputset
        or al, 0b00000001
    .outputset:
        mov [.output], al
    .updateheader:
        mov al, 8 ; header len
        mov [es:si], al
        inc si
        mov al, 1 ; data len
        mov [es:si], al
        add si, 2 ; error code
        mov al, 0
        mov [es:si], al
        add si, 5 ; data contents
        mov al, [.output]
        mov [es:si], al
    .done:
        popa
        retf
    .output: db 0

int09handler:
    pusha
    .available:
        mov al, 1
        mov [keyavailable], al
    .getdata:
        in al, 0x60
        mov [keybuffer], al
    .done:
        mov al, 0x20
        out 0x20, al
        popa
        iret

hang:
    cli
    hlt

keybuffer: db 0
keyavailable: db 0

times 2048-($-$$) db 0