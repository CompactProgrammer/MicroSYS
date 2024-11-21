org 0
bits 16
cpu 186

setup:
    .segments:
        mov ax, 0x07c0
        mov ds, ax
        mov es, ax
        mov ax, 0x0900
        mov ss, ax
    .bootdisk:
        mov [bootdisk], dl
    .stack:
        mov bp, 0
        mov sp, bp
    .video:
        mov ax, 2
        int 0x10

nobootldrmsg: db 'Boot error$'
bootdisk: db 0

printstr:
    pusha
    mov ah, 0x0e
    .loop:
        mov al, [ds:si]
        cmp al, '$'
        je .done
        int 0x10
        inc si
        jmp .loop
    .done:
        popa
        ret

booterror:
    mov si, nobootldrmsg
    call printstr
    mov ax, 0
    int 0x16
    jmp 0xffff:0

times 512-($-$$) db 0
dw 0xaa55

times 1024-($-$$) db 0

vis_signature: db 'FS'
vis_bytespersec: dw 512
vis_secsperblock: db 2
vis_disktype: db 0xf4
vis_secsinvol: dw 2880
vis_secspertrack: dw 18
vis_numofheads: dw 2
vis_volumeid: db 'MSYS'
vis_secsrootfolder: dw 6
vis_secsineft: dw 8
vis_reserved: dd 0
vis_vollabel: db 'MICROSYS'
db '$'

times 1536-($-$$) db 0