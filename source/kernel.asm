org 0
bits 16
cpu 186

jmp setup
db 'KERNEL'
%include 'include/video.inc'
%include 'include/disk.inc'

redrawtop:
    pusha
    mov ax, es
    push ax
    mov ax, 0xb800
    mov es, ax
    .prep0:
        mov cx, 0
        mov si, toptext
        mov di, 0
    .loop0:
        inc cx
        cmp cx, 81
        je .select
        mov al, [ds:si]
        mov [es:di], al
        inc di
        mov al, 0b01110000
        mov [es:di], al
        inc di
        inc si
        jmp .loop0
    .select:
        mov ah, 2
        mov bh, 0
        mov dl, 3
        mov dh, 2
        int 0x10
        mov si, toptext.3
        call printstr
    .done:
        pop ax
        mov es, ax
        popa
        ret

setup:
    .segments:
        mov ax, 0x0100
        mov ds, ax
        mov ax, 0x0800
        mov es, ax
    .bootdisk:
        mov [ds:bootdisk], dl
    .topbar:
        call cls
        call redrawtop
    .currentdirset:
        mov al, 0
        mov si, currentdirlen
        mov [ds:si], al
        inc si
        mov [ds:si], al
    .version:
        mov ax, 16
        mov cx, 1
        mov dl, [ds:bootdisk]
        mov bx, 0
        call readsectors
        jc error
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
        mov dl, [ds:bootdisk]
        mov bx, 0x800
        call readsectors
        jc error

main:
    .setupcursor:
        mov ah, 2
        mov bh, 0
        mov dl, 6
        mov dh, 4
        int 0x10

jmp hang

error:
    mov ah, 2
    mov bh, 0
    mov dl, 21
    mov dh, 10
    int 0x10
    mov si, errormsg.1
    call printstr
    mov dh, 11
    int 0x10
    mov si, errormsg.2
    call printstr
    mov dh, 12
    int 0x10
    call printstr
    mov dh, 13
    int 0x10
    call printstr
    mov dh, 14
    int 0x10
    mov si, errormsg.3
    call printstr
    mov dl, 23
    mov dh, 12
    int 0x10
    mov si, errormsg.0
    call printstr
    mov dh, 25
    int 0x10
hang:
    cli
    hlt

bootdisk: db 0
toptext:
    .0: db 'MicroSYS File Manager'
    .1: times 37 db 0
    .2: db 'Press ALT to show menu'
    .3: db 'Use ', 24, ' and ', 25, ' to navigate, and ENTER to select', 0

currentdirlen: db 0 ; set to 0 if root directory
currentdir: db 0

errormsg:
    .0: db 'MicroSYS has encountered an error', 0
    .1:
        db 201
        times 35 db 205
        db 187, 0
    .2:
        db 186
        times 35 db ' '
        db 186, 0
    .3:
        db 200
        times 35 db 205
        db 188, 0

times 8192-($-$$) db 0