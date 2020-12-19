
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.DATA 
num1 db 100,?
ans db 100 DUP('$')
space db ' $'
.CODE    
MAIN PROC FAR 
mov ax, @DATA
mov ds, ax


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
 

mov bx, ax
push bx
mov bx, 0 
mov dx, offset space
mov ah, 09h
int 21h 
call FIB
;;now we have the answer in BX 
mov ax, bx
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
MOV AH, 4CH
INT 21H
MAIN ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FIB PROC
    pop dx
    pop ax
    push dx
    push ax
    cmp ax, 2
    ja inja
    onja:
        pop dx
        add bx, 1h
        ret
    inja:
        dec ax
        push ax
        call FIB
        pop ax
        dec ax
        dec ax
        push ax
        call FIB
ret    
FIB ENDP
END MAIN




