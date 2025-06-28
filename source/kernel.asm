org 0
bits 16
cpu 186

jmp setup
db 'KERNEL'
%include 'include/video.inc'
%include 'include/disk.inc'

setup:
    .segments:
        mov ax, 0x0100
        mov ds, ax
        mov ax, 0x0800
        mov es, ax
    .bootdisk:
        mov [ds:bootdisk], dl
    .clearscreen:
        call cls
    .loadivt:
        push es
        mov ax, 0
        mov es, ax
        mov bx, 0x0100
        mov ax, reboot
        mov [es:(0x19*4)], ax
        mov [es:(0x19*4)+2], bx
        mov ax, sysfuncs
        mov [es:(0x40*4)], ax
        mov [es:(0x40*4)+2], bx
        mov ax, devloadunload
        mov [es:(0x41*4)], ax
        mov [es:(0x41*4)+2], bx
        mov ax, devaccess
        mov [es:(0x4f*4)], ax
        mov [es:(0x4f*4)+2], bx
        pop ax
        mov es, ax
    .done:
        ret

error:
    mov ah, 0
    mov al, 3
    int 0x10
    mov ax, 0x0100
    mov ds, ax
    mov si, errormsg
    call printstr
    mov ax, 0
    int 0x16
    jmp 0xffff:0
hang:
    cli
    hlt

reboot:
    pop ax
    pop ax
    mov ax, 0xffff
    push ax
    mov ax, 0
    push ax
    iret

devaccess:
    iret

devloadunload:
    iret

sysfuncs:
    cmp ah, 0x00
    je functerm
    cmp ah, 0x01
    je funcgetdefdisk
    cmp ah, 0x02
    je funcsetdefdisk
    cmp ah, 0x03
    je funcintvector
    cmp ah, 0x04
    je funcversion
    cmp ah, 0x05
    je functermstayres
    cmp ah, 0x06
    je funcdrvinfo
    cmp ah, 0x07
    je funcbootdrv
    cmp ah, 0x08
    je funcfreeclus
    cmp ah, 0x09
    je funcprgm
    cmp ah, 0x0a
    je funcallocmem
    cmp ah, 0x0b
    je funcfreemem
    cmp ah, 0x0c
    je funcresizemem
    cmp ah, 0x0d
    je funcexcode
    cmp ah, 0x0e
    je funcgetcd
    cmp ah, 0x0f
    je funcsetcd
    cmp ah, 0x10
    je funcfilecreate
    cmp ah, 0x11
    je funcfileopen
    cmp ah, 0x12
    je funcfileclose
    cmp ah, 0x13
    je funcfilegetpointer
    cmp ah, 0x14
    je funcfilesetpointer
    cmp ah, 0x15
    je funcfileread
    cmp ah, 0x16
    je funcfilewrite
    cmp ah, 0x17
    je funcfiledelete
    cmp ah, 0x18
    je funcfilemov
    cmp ah, 0x19
    je funcfilecopy
    cmp ah, 0x1a
    je funcfilegetattr
    cmp ah, 0x1b
    je funcfilesetattr
    cmp ah, 0x1c
    je funcfileren
    cmp ah, 0x1d
    je funcfilesize
    cmp ah, 0x1e
    je funcfilectime
    cmp ah, 0x1f
    je funcfilemtime
    pusha
    mov si, sp
    sub si, 4
    mov ax, [ss:si]
    or ax, 0b0000000000000001
    mov [ss:si], ax
    popa
    iret

bootdisk: db 0
defaultdisk: db 0
errormsg: db 'MicroSYS has encountered a fatal error. Press any key to reboot.', 0

knldrvheaders:
    .cdrom:
        .cdrom.sign: db 0xde
        .cdrom.length: db 20
        .cdrom.flags: db 0b10000111
        .cdrom.drives: db 1
        .cdrom.load: dw cdromdrv.load
        .cdrom.exec: dw cdromdrv.exec
        .cdrom.segment: dw 0x0100
        .cdrom.memory: dw 0x0400
        .cdrom.id: db '        '
endknldrvheaders:

functerm:
    .exitcode:
        mov si, sp
        sub si, 2
        mov ax, [ss:si]
        mov ds, ax
        mov si, 4
        mov ax, [ds:si]
        mov ds, ax
        mov si, 0x18
        mov [ds:si], bx
    .freealloc:
        mov ah, 0x0b
        mov si, sp
        sub si, 2
        mov bx, [ss:si]
        int 0x40
    .start:
        mov si, sp
        sub si, 2
        mov ax, [ss:si]
        mov ds, ax
        mov si, 4
        mov ax, [ds:si]
        push ax
        cmp al, 1
        je .return
    .terminate:
        mov ax, 0x0000
        push ax
        retf
    .return:
        mov si, 0x1a
        mov ax, [ds:si]
        push ax
        retf

funcgetdefdisk:
    mov ah, [defaultdisk]
    iret

funcsetdefdisk:
    mov [defaultdisk], al
    iret

funcintvector:
    pusha
    push ds
    push ax
    mov ax, 0
    mov ds, ax
    .getaddr:
        pop ax
        mov ah, 0
        mov dx, 4
        mul dx
        mov si, ax
    .setint:
        mov [ds:si], cx
        add si, 2
        mov [ds:si], bx
    .done:
        pop ax
        mov ds, ax
        popa
        iret

funcversion:
    mov ah, '0'
    mov al, '1'
    iret

functermstayres:
    iret

funcdrvinfo:
    iret

funcbootdrv:
    mov al, [bootdisk]
    iret

funcfreeclus:
    iret

funcprgm:
    iret

funcallocmem:
    iret

funcfreemem:
    iret

funcresizemem:
    iret

funcexcode:
    iret

funcgetcd:
    iret

funcsetcd:
    iret

funcfilecreate:
    iret

funcfileopen:
    iret

funcfileclose:
    iret

funcfilegetpointer:
    iret

funcfilesetpointer:
    iret

funcfileread:
    iret

funcfilewrite:
    iret

funcfiledelete:
    iret

funcfilemov:
    iret

funcfilecopy:
    iret

funcfilegetattr:
    iret

funcfilesetattr:
    iret

funcfileren:
    iret

funcfilesize:
    iret

funcfilectime:
    iret

funcfilemtime:
    iret

cdlen: db 0
currentdir: times 512 db 0

cdromdrv:
    .load:
    .exec:

times 16384-($-$$) db 0