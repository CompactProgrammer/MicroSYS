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
        mov ax, sysfuncs
        mov [es:(0x40*4)], ax
        mov [es:(0x40*4)+2], bx
        mov ax, devloadunload
        mov [es:(0x41*4)], ax
        mov [es:(0x41*4)+2], bx
        mov ax, devaccess
        mov [es:(0x4f*4)], ax
        mov [es:(0x4f*4)+2], bx
        mov ax, reboot
        mov [es:(0x19*4)], ax
        mov [es:(0x19*4)+2], bx
        pop es
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
    iret

bootdisk: db 0
defaultdisk: db 0
errormsg: db 'MicroSYS has encountered a fatal error. Press any key to reboot.', 0

functerm:
    iret

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

MAXDRVENTR equ 24
drvtablen: db 20*MAXDRVENTR
drivertable: times (20*MAXDRVENTR) db 0

currentdir: times 512 db 0

times 16384-($-$$) db 0