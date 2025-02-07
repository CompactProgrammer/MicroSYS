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
    pusha
    .saveinputs:
        xchg bx, bx
        mov [.segmentdst], ax
        mov [.fnpointer], si
    .savesegment:
        xchg bx, bx
        mov ax, es
        mov [.essave], ax
    .setsegment:
        xchg bx, bx
        mov ax, 0x0a00
        mov es, ax
    .getrootdir:
        xchg bx, bx
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
        xchg bx, bx
        mov si, [.fnpointer]
        mov di, 1
        mov cx, 512
        .getentry.loop:
            call cmpfn_utf16
            jnc .getentry.found
            mov ax, 0
            mov al, [es:di]
            add di, ax
            loop .getentry.loop
            jmp .error
        .getentry.found:
    .getsize:
        xchg bx, bx
        add di, 0x25
        mov ax, [es:di]
    .getfilesectors:
        xchg bx, bx
        mov dx, 0
        mov bx, [ds:fsinfo.bytespersec]
        div bx
        cmp dx, 0
        je .getblock
        inc ax
        mov [.filesecs], ax
    .getblock:
        xchg bx, bx
        add di, 2
        mov ax, [es:di]
        push ax
    .getbet:
        xchg bx, bx
        mov ax, 0
        mov al, [ds:fsinfo.bootblock]
        mov dh, [ds:fsinfo.secsperbet]
        mov dl, [ds:bootdisk]
        mov bx, 0
        call readsectors
        pop ax
        jc .error
    .getfilelocation:
        xchg bx, bx
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
        xchg bx, bx
        mov ax, [.fileloc]
        mov dh, [.filesecs+1]
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
        clc
        mov ax, [.essave]
        mov es, ax
        popa
        xchg bx, bx
        ret
    .error:
        stc
        mov ax, [.essave]
        mov es, ax
        popa
        xchg bx, bx
        ret
    .segmentdst: resb 2
    .fnpointer: resb 2
    .secsperdir: resb 2
    .fileloc: resb 2
    .filesecs: resb 2
    .essave: resb 2
    .end: db 'LOAD'