format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable
      digitInOut db '%d', 0
      resString db '%d is %s', 0
      evenStr db 'even', 0
      oddStr db 'odd', 0

      temp dd ?


;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        push temp
        push digitInOut
        call [scanf]

        xor edx, edx
        mov eax, [temp]
        mov ebx, 2
        div ebx

        push eax
        push digitInOut
        call [printf]

      ;finish:
        call [getch]
        push 0
        call [ExitProcess]
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'