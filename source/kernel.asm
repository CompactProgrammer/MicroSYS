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

jmp hang

error:
    mov ah, 0
    mov al, 3
    int 0x10
    mov ax, 0x0100
    mov ds, ax
    mov si, errormsg.0
    call printstr
    mov si, errormsg.1
    call printstr
    mov ax, 0
    int 0x16
    jmp 0xffff:0
hang:
    cli
    hlt

devaccess:
    iret

devloadunload:
    iret

sysfuncs:
    iret

bootdisk: db 0

errormsg:
    .0: db 'MicroSYS has encountered a fatal error. Information is below:', 13, 10, 13, 10, 0
    .1: db 13, 10, 13, 10, 'Press any key to reboot.', 0
    .error00: db '0x00: INVALID OPCODE', 0
    .error01: db '0x01: DIVIDE BY ZERO', 0
    .error02: db '0x02: NMI', 0
    .errorff: db '0xff: UNDEFINED ERROR', 0
    .location0: db 13, 10, 'Memory location of error: ', 0
    .location1: db '0000:', 0
    .location2: db '0000', 0
    .stack0: db 13, 10, 'Current stack pointer: ', 0
    .stack1: db '0000:', 0
    .stack2: db '0000', 0

currentdirlen: db 0 ; set to 0 if root directory
currentdir: times 16 db 0

times 16384-($-$$) db 0