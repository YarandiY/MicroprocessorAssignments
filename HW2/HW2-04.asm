
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.DATA
num1 DB 100 DUP('$')
ans DB 100 DUP('$')
space DB ' $'
.CODE
MAIN PROC FAR
mov ax, @DATA
mov ds, ax

mov dx, offset num1
mov ah, 0ah
int 21h 

mov si, offset num1 + 2
mov bx, offset ans
mov cx, 14
BACK:
    mov al, [si]
    cmp al, 0dh
    jz  end
    cmp al, 61h
    jb over
    cmp al, 7ah
    ja over
    and al, 11011111b 
over:
    mov [bx], al
    inc si
    inc bx
    jmp back
    
end:

mov dx, offset space
mov ah, 09h
int 21h  
 
mov dx, offset ans
mov ah, 09h
int 21h

mov ah, 4ch   
int 21h
MAIN ENDP
END MAIN
ret




