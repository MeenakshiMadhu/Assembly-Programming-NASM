section .bss
x	: resq 1
y	: resq 1

section .data
msg1    : db 'Enter x : '
len1    : equ $-msg1
msg2    : db 'Enter y : '
len2    : equ $-msg2
quad1	: db 'QUADRANT 1',0Ah
len_q1	: equ $-quad1
quad2   : db 'QUADRANT 2',0Ah
len_q2  : equ $-quad2
quad3   : db 'QUADRANT 3',0Ah
len_q3  : equ $-quad3
quad4   : db 'QUADRANT 4',0Ah
len_q4  : equ $-quad4
zero	: dq 0
format1 : db "%lf", 0
format2 : db "%lf",10,0
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
fstp qword[x]

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call read_float
fstp qword[y]

fld qword[y]
fld qword[x]
fild qword[zero]	;;ST0=0 , ST1=x , ST2=y

fcomi ST1
jb righthalf
;else in lefthalf 
fcomi ST2
jb print_quad2
;else 
print_quad3:
mov eax, 4
mov ebx, 1
mov ecx, quad3
mov edx, len_q3
int 80h
call exit

print_quad2:
mov eax, 4
mov ebx, 1
mov ecx, quad2
mov edx, len_q2
int 80h
call exit


righthalf:
fcomi ST2
jb print_quad1
;else
print_quad4:
mov eax, 4
mov ebx, 1
mov ecx, quad4
mov edx, len_q4
int 80h
call exit

print_quad1:
mov eax, 4
mov ebx, 1
mov ecx, quad1
mov edx, len_q1
int 80h
call exit
;;----------Exit system call---------------------------
exit:
ffree ST0
ffree ST1
ffree ST2
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
