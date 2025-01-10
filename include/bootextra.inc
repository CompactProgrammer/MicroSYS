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

; INPUT
; ax    segment to load file to
; si    pointer to filename
loadfile:
    clc
    .saveinputs:
        mov [.segmentdst], ax
        mov [.fnpointer], si
    .segment:
        mov ax, 0x0a00
        mov es, ax
    .getrootdir:
        mov ax, 0
        mov al, [ds:fsinfo.bootblock]
        mov cx, 0
        mov cl, [ds:fsinfo.secsperbet]
        add ax, cx
        push ax
        mov al, [ds:fsinfo.blocksperdir]
        mov bl, [ds:fsinfo.secsperblock]
        mul bl
        mov dh, al
        mov [.secsperdir], ax
        pop ax
        mov dl, [ds:bootdisk]
        mov bx, 0
        call readsectors
        jc .error
    .getentry:
        mov si, [.fnpointer]
        mov di, 0
        mov cx, 512
        .getentry.loop:
            call cmpfn_utf16
            jnc .getentry.found
            mov ax, 0
            mov al, [es:si]
            add si, ax
            loop .getentry.loop
            jmp .error
        .getentry.found:
    .getblock:
        add si, 0x28
        mov ax, [es:si]
        push ax
    .getbet:
        mov ax, 0
        mov al, [ds:fsinfo.bootblock]
        mov dh, [ds:fsinfo.secsperbet]
        mov dl, [ds:bootdisk]
        mov bx, 0
        call readsectors
        jc .error
    .getfilelocation:
        pop ax
        mov bx, 0
        mov bl, [fsinfo.secsperblock]
        mul bx
        mov bx, 0
        add bl, [fsinfo.bootblock]
        add ax, bx
        mov bx, 0
        add bl, [fsinfo.secsperbet]
        add ax, bx
        add ax, [.secsperdir]
        mov [.fileloc], ax
    .readfile:
        mov ax, [.fileloc]
        mov dh, 16
        mov dl, [bootdisk]
        mov bx, 0
        push ax
        mov ax, [.segmentdst]
        mov es, ax
        pop ax
        call readsectors
        jc .error
        call lbatochs
    .done:
        popa
        ret
    .error:
        stc
        jmp .done
    .segmentdst:
        resb 2
    .fnpointer:
        resb 2
    .secsperdir: resb 2
    .fileloc: resb 2