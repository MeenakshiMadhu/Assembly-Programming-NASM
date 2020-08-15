section .bss
float1: resq 1
sum   : resq 1

section .data
msg1    : db 'Enter x : '
len1    : equ $-msg1
msg2    : db 'f(x)= x^3 + x^2 - 5x + 9 = : '
len2    : equ $-msg2
five    : dq -5
nine    : dq 9
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

fild qword[nine]     ;;ST2
fild qword[five]     ;;ST1
fld qword[float1]    ;;ST0


fmul ST1  ;;ST0=-5x
fadd ST2  ;;ST0=-5x+9 
ffree ST1
ffree ST2
;;now stack is :ST0 = -5x+9


fld qword[float1]
fmul ST0
fadd ST1
ffree ST1
;;now stack is : ST0 = x^2-5x+9


fld qword[float1]
fld qword[float1]
fmul ST1
fmul ST1
fadd ST2
ffree ST2
ffree ST1
;;now stack is : ST0 = x^3+x^2-5x+9

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call print_float

ffree ST0

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

;;--------------PRINT NEWLINE---------------------------
print_newline:
pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa
ret
