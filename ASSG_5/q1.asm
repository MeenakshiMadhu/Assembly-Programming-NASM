section .bss
celcius: resq 1

section .data
msg1    : db 'Enter temp in Celcius: '
len1    : equ $-msg1 
msg2    : db 'Fahrenheit equivalent is : '
len2    : equ $-msg2
format1 : db "%lf", 0
format2 : db "%lf", 10
floatc  : dq 1.8
float32 : dq 32
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
fstp qword[celcius]  

fild qword[float32]  ;;ST2
fld qword[floatc]    ;;ST1
fld qword[celcius]   ;;ST0
;;fmul => ST0 = ST0 x src
fmul ST1
;;fadd => ST0 = ST0 + src
fadd ST2

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call print_float

ffree ST0
ffree ST1
ffree ST2

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

