section .data
msg1 : db "enter no of strings- "
l1: equ $-msg1
msg2: db "enter the strings - "
l2: equ $-msg2
msg3: db "strings in sorted order- "
l3: equ $-msg3
space: db " "
sz: equ $-space
nl : db "",0Ah
nls: equ $-nl


section .bss
    digit : resw 1
    a     : resw 1
    s     : resw 1
    count2   : resw 1
    b : resw 1
    smallest : resw 1
    count1 : resw 1
    d    : resw 1
    pos    : resw 1
    num   : resw 1
    count : resw 1
    n     : resw 1
    arr   : resw 300
    arr1  : resw 100
    sm : resw 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,l1
int 80h
call readno
mov ax,word[num]
mov word[n],ax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h
call newline

call readnstrings

mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,l3
int 80h

call newline


sortstrings:
       mov word[count],0
       loopd1: 
           movzx edx,word[count]
           mov ax,word[arr1+edx*2]
           mov word[smallest],ax
           mov ax,word[count]
           mov word[pos],0
           cmp word[n],ax
                    je endsort
           mov ax,word[count]
           mov word[count1],ax
           loopd2:
               mov ax,word[count1]
               cmp word[n],ax
                    je endloopd2
               movzx edx,word[count1]
               mov ax,word[arr1+edx*2]
               mov word[b],ax
               call check
               inc word[count1]
               jmp loopd2
           endloopd2:
               movzx edx,word[count]
               mov ax,word[arr1+edx*2]
               mov bx,word[smallest]
               mov word[arr1+edx*2],bx
               movzx edx,word[pos]
               mov word[arr1+edx*2],ax
               inc word[count]
               call printstring
               call newline
               jmp loopd1
        endsort:
            call exit
 
    
check:
    pusha
    mov ax,word[b]
    mov word[a],ax
    mov ax,word[smallest]
    mov word[sm],ax
    loopch1:
        movzx edx,word[a]
        mov ax,word[arr+edx*2]
        mov word[s],ax
        movzx edx,word[sm]
        mov ax,word[arr+edx*2]
        cmp word[s],10
               je new
        cmp ax,10
               je current
        cmp word[s],ax
               ja current
        cmp word[s],ax
               jb new
        inc word[a]
        inc word[sm]    
        jmp loopch1
   current:
        jmp endcheck1
   new:
      mov ax,word[b]
      mov word[smallest],ax
      mov ax,word[count1]
      mov word[pos],ax
   endcheck1:
         popa
         ret
  
printstring:
    pusha
    mov ax,word[smallest]
    mov word[count2],ax
    looppr:
       movzx edx,word[count2]
       mov ax,word[arr+edx*2]
       cmp ax,10
              je endprintr
       mov word[num],ax
       mov eax,4
       mov ebx,1
       mov ecx,num
       mov edx,1
       int 80h 
       inc word[count2]
       jmp looppr
   endprintr:
       popa
       ret

readnstrings:
    pusha
    mov word[count1],0 
    mov word[count],0
    looprn:
         mov ax,word[count1]
         cmp ax,word[n]
                je endreadn
         mov ax,word[count]
         movzx edx,word[count1]
         mov word[arr1+edx*2],ax
         call readstring
         inc word[count1]
         jmp looprn
    endreadn:
         popa
         ret    
readstring:
    pusha
    loopr:
       call readch
       mov ax,word[num]
       movzx edx,word[count]
       mov word[arr+edx*2],ax
       inc word[count]
       cmp word[num],10
              je endreadstring
       jmp loopr
    endreadstring:
       popa
       ret
printno:
     pusha
     mov ax,23
     push ax
     mov ax,word[num]
     getdigit:
        mov dx,0 
        mov bx,10 
        div bx 
        push dx
        cmp ax,0
          jne getdigit
     printdigit:
          pop dx
          cmp dx,23
          je return1
          add dx,30h
          mov word[digit],dx
          mov eax,4
          mov ebx,1
          mov ecx,digit
          mov edx,1
          int 80h
          jmp printdigit
     return1:
          popa
          ret
readno:
     pusha
     mov word[num],0
     mov bx,10
     getd1:
       mov eax,3
       mov ebx,0
       mov ecx,digit
       mov edx,1
       int 80h
       cmp word[digit],10
           je return 
       sub word[digit],30h
       mov ax,word[num]
       mov bx,10
       mul bx
       add ax,word[digit]
       mov word[num],ax
       jmp getd1
    return:
      popa     
      ret

readch:
    pusha
    mov word[num],0
    readdigit:
      mov eax,3
      mov ebx,0
      mov ecx,digit
      mov edx,1
      int 80h
      mov ax,word[digit]
      mov word[num],ax
    endread:
       popa
       ret
newline:
    pusha
    mov eax,4
    mov ebx,1
    mov ecx,nl
    mov edx,nls
    int 80h
    popa
    ret
exit: 


   mov eax,1
   mov ebx,0
   int 80h


