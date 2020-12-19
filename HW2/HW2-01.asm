
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.DATA   
space db ' $'
num1 db 100 DUP('$')
num2 db 100 DUP('$') 
ans  db 100 DUP('$')
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
mov bp,ax

mov dx, offset space
mov ah, 09h
int 21h  

;;;;;;;;;second number;;;;;;;;
mov dx, offset num2
mov ah, 0ah
int 21h   
  

mov dh,0 
mov cl, 0ah
mov bx, offset num2 + 2 
mov dl,[bx]
mov ax,0  
a3:
    cmp dl,0Dh
    jz a4
    mul cl
    sub dl,30h 
    add ax, dx
    inc bx
    mov dl,[bx]
    jmp a3
a4:
mov sp, ax
mov dx, offset space
mov ah, 09h
int 21h  


;;;;;;;;;setup AX and BX;;;;;;;    
mov bx, sp
mov ax, bp 
mov dx, 0
cmp ax,bx
jae myloop
mov bp,ax
mov ax,bx
mov bx,bp 
;now we have the greater number in AX and the another one in BX    
    
myloop:
    mov dx, 0
    cmp bx, 0
    jz there
    div bx
    mov ax, bx
    mov bx, dx 
    jmp myloop       

there: 
mov dx, ax
;now we have the answer in DX :)


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




