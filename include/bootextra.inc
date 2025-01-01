serialoutstr:
    clc
    pusha
    mov dx, 0
    .loop:
        mov ah, 1
        mov al, [ds:si]
        cmp al, '$'
        je .done
        int 0x14
        test ah, 0b00000001
        jnz .error
        inc si
        jmp .loop
    .error:
        stc
    .done:
        popa
        ret

loadconfig:

ret

loadkernel:

ret