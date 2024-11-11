org 0x7c00
bits 16

setup:
    .bootdisk:
        mov [bootdisk], dl
    .segments:
        mov ax, 0
        mov ds, ax
        mov es, ax
        mov ss, ax
    .stack:
        mov bp, 0x8000
        mov sp, bp

loadbootblock:
    mov ah, 2
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdisk]
    mov bx, 0x7e00
    int 0x13
    jc loadbootblock
    jmp 0x7e00

nobootldrmsg: db 'No bootloader found$'
bootdisk: db 0

printstr:
    pusha
    mov ah, 0x0e
    .loop:
        mov al, [si]
        cmp al, '$'
        je .done
        int 0x10
        inc si
        jmp .loop
    .done:
        popa
        ret

times 512-($-$$) db 0
dw 0xaa55

findrootdir:
    mov ax

times 1024-($-$$) db 0

vis_signature: db 'FS'
vis_bytespersec: dw 512
vis_secsperblock: db 2
vis_disktype: db 0xf7
vis_secsinvol: dw 1440
vis_secspertrack: dw 9
vis_numofheads: dw 2
vis_volumeid: db 'MSYS'
vis_entriesperfolder: dw 128
vis_secsineft: dw 0
vis_reserved: dd 0
vis_vollabel: db 'MICROSYS'

times 1536-($-$$) db 0