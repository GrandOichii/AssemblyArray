format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable
        sizePrompt db 'Enter the size of vector: ', 0
        sizeFail db 'Vector size has to be between 0 and 100', 0
        digitIn db '%d', 0

        tmpStack dd ?
        vec_size dd ?



;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call InputVector
        call Finish

InputVector:
        mov [tmpStack], esp
        ; input the size of the vector
        push sizePrompt
        call [printf]

        push vec_size
        push digitIn
        call [scanf]

        mov eax, [vec_size]
        cmp eax, 0
        jle fail
        cmp eax, 100
        jg fail

        push eax
        push digitIn
        call [printf]

        mov esp, [tmpStack]
        ret

        fail:
                push sizeFail
                call [printf]
                call [getch]
                push 0
                call [ExitProcess]


Finish:
        call [getch]
        push 0
        call [ExitProcess]

                                                 
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