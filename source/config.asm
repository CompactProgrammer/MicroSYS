config:
dw __utf16__('DEVICE=\MICROSYS\DRIVERS\KEYBOARD.DEV'), 13, 10
dw __utf16__('SHELL=\MICROSYS\SYSSHELL.EXE'), 13, 10
dw __utf16__('COUNTRY=USA'), 13, 10
dw __utf16__('REM Comment on this file'), 13, 10

times 1024-($-$$) db 0