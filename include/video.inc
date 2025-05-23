printchar:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret
    
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

newline:
    pusha
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    popa
    ret

cls:
    pusha
    mov ah, 0
    mov al, 3
    int 0x10
    popa
    ret

printerror:
    pusha
    .print:
        push si
        mov si, .error
        call printstr
        pop si
        call printstr
    .done:
        popa
        ret
    .error: db 13, 10, '[ERROR] $'