
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.DATA
num1 db 100 DUP('$') 
ans db 100 DUP('$')
space db ' $' 
overflow db 'overflow! $'
.CODE
MAIN PROC FAR
    
mov ax, @DATA
mov ds, ax

;;;;;;;;;first number;;;;;;;;
mov dx, offset num1
mov ah, 0ah
int 21h 
 

mov dh,0 
mov cl, 0ah
mov bx, offset num1 + 2 
mov dl,[bx]
mov ax,0  
a2:
    cmp dl,0Dh
    jz a1
    mul cl
    sub dl,30h 
    add ax, dx
    inc bx
    mov dl,[bx]
    jmp a2
a1:
;;;;;;;;;;;;;;now we have the number in AX

 
 
mov bp, ax
mov dx, offset space
mov ah, 09h
int 21h      

cmp bp, 9h
jb halle
mov dx, offset overflow
mov ah, 09h
int 21h  
jmp end12 
    

halle:  
mov ax, 0h
mov al, 1h
mov dx, 1h
mainLoop:
    cmp bp, 0h
    jz endMain
    mov ax, bp 
    mul dx
    mov dx, ax
    dec bp
    jmp mainLoop
endMain:

 
;;;;;;store the answer in the memory;;;;;; 
mov bx, offset ans 
mov bp, ax
mov cx, 0ah
b3:
    cmp ax, 0ah
    jb b2  
    mov dx, 0
    div cx
    add dx, 30h
    mov [bx], dx 
    inc bx
    jmp b3
b2:
add ax, 30h
mov [bx], ax 


;;;;;;print the answer;;;;;
b4: 
    mov al, 0
    mov al, [bx]
    cmp al, 30h
    jb end12
    cmp al, 39h
    ja end12 
    mov dx, [bx]
    mov ah, 02h
    int 21h 
    dec bx
    jmp b4 
end12:


mov ah, 4ch     
int 21h
MAIN endp
END MAIN    




