section .bss
float1: resq 1
float2: resq 1

section .data
msg1    : db 'Enter float 1 : '
len1    : equ $-msg1
msg2    : db 'Enter float 2 : '
len2    : equ $-msg2
msg3    : db 'Product is : '
len3    : equ $-msg3
format1 : db "%lf", 0
format2 : db "%lf",10
newline : dw 10

section .text
global main:
extern scanf
extern printf

main:
mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, len1
int 80h

call read_float
fstp qword[float1]

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call read_float
fstp qword[float2]

fld qword[float1]    ;;ST1
fld qword[float2]    ;;ST0
;;fmul => ST0 = ST0 x src
fmul ST1

mov eax, 4
mov ebx, 1
mov ecx, msg3
mov edx, len3
int 80h

call print_float
ffree ST0
ffree ST1
;;----------Exit system call---------------------------
exit:
mov eax, 1
mov ebx, 0
int 80h


;;-----------READ FLOATING POINT------------------------
read_float:
push ebp
mov ebp, esp
sub esp, 8
lea eax, [esp]
push eax
push format1
call scanf
fld qword[ebp - 8]
mov esp, ebp
pop ebp
ret

;;-------------PRINT FLOATING POINT--------------------
print_float:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp - 8]
push format2
call printf
mov esp, ebp
pop ebp
ret
