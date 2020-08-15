;;-----------------------SORTING AN ARRAY OF N FLOATS-----------------------
section .bss
n	: resw 10
arr	: resq 60
num	: resw 10
temp	: resb 10
count	: resb 10
j	: resd 1
i	: resd 1
key	: resq 1

section .data
msg1    : db 'Enter n : '
len1    : equ $-msg1
msg2    : db 'Sorted array : ',0Ah
len2    : equ $-msg2
msg3    : db 'Enter element : '
len3    : equ $-msg3
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

call read_num
mov cx, word[num]
mov word[n], cx

call read_array

call ins_sort

mov eax, 4
mov ebx, 1
mov ecx, msg2
mov edx, len2
int 80h

mov ebx, arr
mov eax, 0
call print_array


ffree ST0
ffree ST1
;;----------Exit system call---------------------------
exit:
mov eax, 1
mov ebx, 0
int 80h

;;------------INSERTION SORT---------------------------

;    int i, key, j; 
;    for (i = 1; i < n; i++) 
;	{ 
  ;      key = arr[i]; 
   ;     j = i - 1; 
      
;        while (j >= 0 && arr[j] > key)
;            arr[j + 1] = arr[j]; 
;            j = j - 1; 
;        
;        arr[j + 1] = key; 
;       }  

ins_sort:
pusha
mov eax, 0
mov ebx, arr
inc eax
mov dword[i], eax	;i = 1

sort:
mov ebx, arr
mov eax, dword[i]
cmp eax,dword[n] 
je end_sort

fld qword[ebx+8*eax]
fstp qword[key]		;;key =arr[i]

mov ecx, dword[i]
dec ecx
mov dword[j], ecx 		;; j=i-1

whileloop:
call clearStack
cmp dword[j], 0
jb end_whileloop
jmp if2

;check arr[j]>key
if2:
mov eax, dword[j]
mov ebx, arr
fld qword[key]		;;ST1
fld qword[ebx+8*eax]	;;ST0
mov ebx,arr
fcomi ST1
jna end_whileloop


;    arr[j + 1] = arr[j];
;    j = j - 1;
mov eax, dword[j]
mov ebx, arr
fld qword[ebx+8*eax]
inc eax
fstp qword[ebx+8*eax]	;;arr[j + 1] = arr[j];
dec eax
dec eax
mov dword[j], eax
jmp whileloop

end_whileloop:
;        arr[j + 1] = key;
mov ebx, arr
mov eax, dword[j]
inc eax
fld qword[key]
fstp qword[ebx+8*eax]
inc dword[i]
jmp sort

end_sort:
popa 
ret

;;------------READ FLOAT_ARRAY-------------------------
read_array:
pusha
mov eax, 0
read_loop:
cmp eax,dword[n]
je end_read_array

pusha
mov eax, 4
mov ebx, 1
mov ecx, msg3
mov edx, len3
int 80h
popa

push eax
call read_float
pop eax

fstp qword[arr+8*eax]
inc eax
jmp read_loop

end_read_array:
popa
ret

;;-----------PRINT FLOAT_ARRAY-------------------------
print_array:
pusha
mov eax, 0
print_loop:
cmp eax,dword[n]
je end_print_array
fld qword[arr+8*eax]

push eax
call print_float
pop eax

inc eax
jmp print_loop

end_print_array:
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

;;------------------CLEARSTACK----------------------------
clearStack:
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
