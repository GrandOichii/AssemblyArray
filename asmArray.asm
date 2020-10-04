format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable
        sizePrompt db 'Enter the size of vector: ', 0
        sizeFail db 'Vector size has to be between 0 and 100', 0
        digitIn db '%d', 0
        elementOut db '[%d] -- %d', 10, 0

        tmpStack dd ?
        vec_size_a dd 0
        tmp dd ?
        i dd ?
        vec_a rd 100



;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call InputVectorA
        call PrintVectorA
        call Finish


InputVectorA:
        mov [tmpStack], esp
        ; input the size of the vector
        push sizePrompt
        call [printf]

        push vec_size_a
        push digitIn
        call [scanf]

        mov eax, [vec_size_a]
        cmp eax, 0
        jle fail
        cmp eax, 100
        jg fail

        xor ecx, ecx
        mov ebx, vec_a

        vectorLoop:
                mov [tmp], ebx
                cmp ecx, [vec_size_a] ; check if last element
                jge endInput

                mov [i], ecx

                push ebx
                push digitIn
                call [scanf] ; input element

                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp vectorLoop

                endInput:
                        mov esp, [tmpStack]
                        ret


        fail:
                push sizeFail
                call [printf]
                call [getch]
                push 0
                call [ExitProcess]

PrintVectorA:
        mov [tmpStack], esp

        xor ecx, ecx
        mov ebx, vec_a

        printVecALoop:
                mov [tmp], ebx
                cmp ecx, [vec_size_a]
                jge endPrintVectorA

                mov [i], ecx

                push dword [ebx]
                push [i]
                push elementOut
                call [printf]

                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp printVecALoop

                endPrintVectorA:
                        mov esp, [tmpStack]
                        ret


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