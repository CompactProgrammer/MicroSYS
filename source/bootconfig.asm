shell: db 'SHELL=MICROSYS\SHELL.EXE'
autoexec: db 13, 10, 'AUTOEXEC=MICROSYS\AUTOEXEC.CMD'
country: db 13, 10, 'COUNTRY=USA'

times 2048-($-$$) db 0