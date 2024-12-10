org 0x0000
bits 16
cpu 186

%include 'include/video.inc'

loadconfig:

hang:
    cli
    hlt

filenames:
    .config: dw __utf16__('CONFIG      SYS $')
    .kernel: dw __utf16__('SYSKERNEL   SYS $')
    .shell: dw __utf16__('SHELL       EXE $')
    .drivers: dw __utf16__('DRIVERS         $')
    .microsys: dw __utf16__('MICROSYS        $')

times 8192-($-$$) db 0