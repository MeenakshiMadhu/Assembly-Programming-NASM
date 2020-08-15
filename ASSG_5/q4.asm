section .bss
n	: resw 10
x	: resq 1
temp	: resb 10
num	: resw 10
count	: resb 10
i	: resd 1
p	: resd 1
term	: resq 1
sum	: resq 1
f	: resd 1

section .data
msg1    : db 'Enter n : '
len1    : equ $-msg1
msg2    : db 'Enter x : '
len2    : equ $-msg2
msg3    : db 'COS(x) = : '
len3    : equ $-msg3
msg4    : db 'factorial = '
len4    : equ $-msg4
format1 : db "%lf", 0
format2 : db "%lf",10,0
newline : dw 10
;p	: dd 4
two	: dd 2
one	: dq 1

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
call read_num
mov cx, word[num]
mov word[n],cx

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h
call read_float
fstp qword[x]

;;	for( i= 0; i< n; i++)
;;	{ p = i*2; 
;;	  term = pow(x, p)
;;	  f = fact(p);
;;	  term=term/f
;;	  if(i%2 ==0)
;;		sum+=term
;;	  else
;;		sum-=term
;;	}

fldz
fstp qword[sum]		;sum = 0

cosine:
pusha
mov eax,0
mov dword[i], eax	;i=0

for:
pusha
call clearStack
mov eax, dword[i]
cmp eax, dword[n]
je end_for


add eax, eax
mov dword[p],eax	;p = 2i
mov eax, dword[i]

call power		; here we get pow(x,p) in term
call clearStack
call factorial		; here we get fact(p) in f

fild dword[f]	;;ST1
fld qword[term]	;;ST0
fdiv ST1	;;ST0 = term/f
fld qword[sum]		;ST0 = sum, ST1 = term/f, ST2 =  f

pusha
mov edx, 0
mov eax, dword[i]
mov ebx, dword[two]
div ebx
cmp edx,0
je addterm

subterm:
fsub ST1
fst qword[sum]
popa
inc dword[i]
jmp for

addterm:
fadd ST1
fst qword[sum]
inc dword[i]
popa
jmp for

end_for:
popa 

end_cosine:
popa


mov eax, 4
mov ebx, 1
mov ecx, msg3
mov edx, len3
int 80h

fld qword[sum]
call print_float
call clearStack

;;----------Exit system call---------------------------
exit:
mov eax, 1
mov ebx, 0
int 80h

;;----------FACTORIAL----------------------------------
factorial:	;;f = fact(p)
pusha
mov eax,0
inc eax
mov dword[f], 0
inc dword[f]		;;f = 1

fact_loop:
cmp eax, dword[p]
ja end_fact_loop
pusha
mov ebx, dword[f]
mul ebx
mov dword[f], eax
popa
inc eax
jmp fact_loop

end_fact_loop:
popa 
ret

;;----------POWER--------------------------------------
power:	;;pow(x,p)
pusha 
fld1
mov eax, 0
pow_loop:
cmp eax, dword[p]
je end_pow_loop
fld qword[x]
fmul ST1
inc eax
jmp pow_loop

end_pow_loop:
fstp qword[term]

popa
ret

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

;;-------------READ NUMBER------------------------------
read_num:
pusha
mov word[num], 0

loop_read:
;; read a digit
mov eax, 3
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h

cmp byte[temp], 10
je end_read

mov ax, word[num]
mov bx, 10
mul bx
mov bl, byte[temp]
sub bl, 30h
mov bh, 0
add ax, bx
mov word[num], ax
jmp loop_read

end_read:
popa
ret

;;--------------PRINT NUMBER----------------------
print_num:
mov byte[count],0
pusha

extract_no:
cmp word[num], 0
je print_no

inc byte[count]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax
jmp extract_no

print_no:
cmp byte[count], 0
je end_print
dec byte[count]
pop dx
mov byte[temp], dl
add byte[temp], 30h

mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h

jmp print_no

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h
ret

clearStack :
 pusha
 ffree ST0
 ffree ST1
 ffree ST2
 ffree ST3
 ffree ST4
 ffree ST5
 ffree ST6
 ffree ST7
 popa 
 ret
