maxfiles: db 'MAXFILES 10', 13, 10
stack: db 'STACK 2048', 13, 10
shell: db 'SHELL MICROSYS\CMDPRMPT.APP', 13, 10, 0
drivers:
    .keybrd: db 'DRIVER MICROSYS\KEYBRD.SYS', 13, 10, 0

times 2048-($-$$) db 0