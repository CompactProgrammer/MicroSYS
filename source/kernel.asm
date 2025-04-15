org 0
bits 16
cpu 186

jmp setup
db 'KERNEL'
%include 'include/boot.inc'

setup:
    .segments:
        mov ax, 0x0100
        mov ds, ax
        mov ax, 0x0800
        mov es, ax
    .bootdisk:
        mov [bootdisk], dl

main:
    .loadbootcfg:
        mov si, sysdir
        mov di, bootcfgfile
        mov bx, 0
        mov dl, [bootdisk]
        call loadfile
        jc booterror

booterror:
    mov si, booterrormsg
    call printstr
hang:
    cli
    hlt

sysdir: db 'MICROSYS', 0
bootcfgfile: db 'BOOTCFG.SYS', 59, 1, 0
bootdisk: db 0
booterrormsg: db 13, 10, 'Error starting MicroSYS', 0

; INPUT
; ds:si pointer to filename 1
; es:di pointer to filename 2
cmpfnseg:
    clc
    pusha
    .loop:
        mov ah, [ds:si]
        mov al, [es:di]
        cmp ah, 0
        je .done
        cmp ah, al
        jne .notfound
        inc si
        inc di
        jmp .loop
    .notfound:
        stc
    .done:
        popa
        ret

loadfile:
    clc
    pusha
    .save:
        mov [ds:.dir], si
        mov [ds:.file], di
        mov ax, es
        mov [ds:.essave], ax
        mov [ds:.bxsave], bx
        mov [ds:.disk], dl
    .segment:
        mov ax, 0x0800
        mov es, ax
    .pvd:
        mov ax, 16
        mov cx, 1
        mov dl, [ds:.disk]
        mov bx, 0
        call readsectors
        jc .error
    .getrootdir:
        mov si, 0xa6
        mov ax, [es:si]
        mov dx, 0
        mov bx, 2048
        div bx
        cmp dx, 0
        je .getrootdir.nocarry
        inc ax
        .getrootdir.nocarry:
        mov cx, ax
        mov si, 0x9e
        mov ax, [es:si]
        mov dl, [ds:.disk]
        mov bx, 0
        call readsectors
        jc .error
    .findfolder:
        mov cx, 60
        mov si, [ds:.dir]
        mov di, 0
        .findfolder.loop:
            dec cx
            add di, 33
            call cmpfnseg
            jnc .findfolder.found
            cmp cx, 0
            je .error
            sub di, 33
            mov ah, 0
            mov al, [es:di]
            add di, ax
            jmp .findfolder.loop
        .findfolder.found:
            sub di, 23
            mov ax, [es:di]
            mov dx, 0
            mov bx, 2048
            div bx
            cmp dx, 0
            je .findfolder.found.nocarry
            inc ax
            .findfolder.found.nocarry:
            mov cx, ax
            sub di, 8
            mov ax, [es:di]
            mov dl, [ds:.disk]
            mov bx, 0
            call readsectors
            jc .error
    .findfile:
        mov cx, 60
        mov si, [ds:.file]
        mov di, 0
        .findfile.loop:
            dec cx
            add di, 33
            call cmpfnseg
            jnc .findfile.found
            cmp cx, 0
            je .error
            sub di, 33
            mov ah, 0
            mov al, [es:di]
            add di, ax
            jmp .findfile.loop
        .findfile.found:
            sub di, 23
            mov ax, [es:di]
            mov dx, 0
            mov bx, 2048
            div bx
            cmp dx, 0
            je .findfile.found.nocarry
            inc ax
            .findfile.found.nocarry:
            mov cx, ax
            sub di, 8
            mov ax, [es:di]
            mov dl, [ds:.disk]
            mov bx, [ds:.essave]
            mov es, bx
            mov bx, [ds:.bxsave]
            call readsectors
            jnc .done
    .error:
        stc
    .done:
        mov ax, [ds:.essave]
        mov es, ax
        popa
        ret
    .dir: dw 0
    .file: dw 0
    .essave: dw 0
    .bxsave: dw 0
    .disk: db 0

times 2048-($-$$) db 0

times 8192-($-$$) db 0