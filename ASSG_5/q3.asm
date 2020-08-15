section .data
msg1    : db "Enter a : ",0
len1    : equ $-msg1
msg2    : db "Enter b : ",0
len2    : equ $-msg2
msg3    : db "Enter c : ",0
len3    : equ $-msg3
msg4    : db "Roots are : ",0
len4    : equ $-msg4
msg5    : db "IMAGINARY ROOTS",0Ah
len5    : equ $-msg5
root1   : db "Root 1 = ",0
len_r1  : equ $-root1
root2   : db "Root 2 = ",0
len_r2  : equ $-root2
format1 : db "%lf",0
format2 : db "%lf", 10,0
four    : dq -4
two     : dq 2
zero    : dq 0
newline : dw 10

section .bss
a: resq 1
b: resq 1
c: resq 1
temp1: resq 1
temp2: resq 1

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
fstp qword[a]

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

call read_float
fstp qword[b]

mov eax, 4
mov ebx, 1
mov ecx, msg3
mov edx, len3
int 80h

call read_float
fstp qword[c]


fild qword[four]  ;;ST2
fld qword[a]      ;;ST1
fld qword[c]      ;;ST0
fmul ST1
fmul ST2
ffree ST1
ffree ST2
;;now stack is : ST0 = -4ac

fld qword[b]
fmul ST0
fadd ST1
ffree ST1
;;now stack is : ST0 = b^2-4ac

fild qword[zero]
fcomip ST1
ja imaginary

fsqrt

fld qword[b]    ;;ST0=b , ST1=sqrt(D)
fchs		;;ST0=-b , ST1=sqrt(D)
fadd ST1	;;ST0=-b+sqrt(D) , ST1=sqrt(D)

fild qword[two]
fld qword[a]	;;ST0=a , ST1=2 , ST2=-b+sqrt(D) , ST3=sqrt(D)
fmul ST1
fdivr ST2	;; ST0=root1, ST1=2, ST2=-b+sqrt(D) , ST3=sqrt(D)

mov eax, 4
mov ebx, 1
mov ecx, root1
mov edx, len_r1
int 80h

call print_float  ;;here we are printing root 1


fstp qword[temp1]
fstp qword[temp2]	;;ST0=-b+sqrt(D) , ST1=sqrt(D)

fsub ST1
fsub ST1	;;ST0=-b-sqrt(D) , ST1=sqrt(D)
fild qword[two]
fld qword[a]    ;;ST0=a , ST1=2 , ST2=-b-sqrt(D) , ST3=sqrt(D)
fmul ST1
fdivr ST2       ;; ST0=root2, ST1=2, ST2=-b-sqrt(D) , ST3=sqrt(D)

mov eax, 4
mov ebx, 1
mov ecx, root2
mov edx, len_r2
int 80h

call print_float

ffree ST0
ffree ST1
ffree ST2
ffree ST3

;;---------------EXIT----------------------------
exit:
mov eax, 1
mov ebx, 0
int 80h

;;--------------IMAGINARY ROOTS-------------------
imaginary:
mov eax, 4
mov ebx, 1
mov ecx, msg5
mov edx, len5
int 80h

call exit

;;----------------READ FLOATING POINT--------------
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

;;--------------PRINT FLOATING POINT---------------
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

;;-------------PRINT NEWLINE------------------------
print_newline:
pusha
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, 1
int 80h
popa
ret
