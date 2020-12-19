
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.DATA   
space db ' $'
num1 db 100 DUP('$')
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
;;;;;;;;;now we have the number in AX   
mov bp,ax

mov dx, offset space
mov ah, 09h
int 21h

mov ax, bp
mov dx, 1
shiftLoop:
    shl bp,1
    jnc shiftLoop
shr ax,1
jnc false

checkLoop:
    cmp bp, 0
    jz checkAX
    cmp ax, 0
    jz false
    shl bp, 1
    jnc sefre
    shr ax, 1
    jnc false
    jmp checkLoop
    sefre:
        shr ax, 1
        jc false
    jmp  checkLoop
checkAx:
    cmp ax, 0
    jz end 

  
false:
    mov dx, 0
;;;;;;;;;;;;;now we have the answer in the DX register
end:
    add dx, 30h
    mov bx, offset ans
    mov [bx], dx
    mov dx, offset ans
    mov ah, 09h
    int 21h 
        
mov ah, 4ch  
int 21h
MAIN endp
END MAIN




