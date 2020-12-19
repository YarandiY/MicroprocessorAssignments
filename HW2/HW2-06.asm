
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.DATA
array db  9h, 12h, 0h, 1h, 5h, 6h, 7h, 2h, 3h, 4h, 8h, 13h, 14h, 0bh, 0ch, 0dh, 0eh, 0fh, 10h, 15h, 16h, 0ah, 11h, 17h, 18h 
.CODE
MAIN PROC FAR 
mov ax, @DATA
mov ds, ax

mov dx, offset array
mov ax, 1000h
mov cl, 25d ;;the length of the array 
     
     
back:
mov bx, dx
mov ch, [bx]
mov bx, ax
mov [bx], ch
inc ax
inc dx
mov ch, 0
dec cl
;loop back
cmp cl, 0
jnz back
;;;;;;Now we have the array on offset 1000

;;key = al
;;i = cx
;; j = dx

mov cx, 1001h
mov ax, 0
mainLoop:
    mov bx, cx
    mov al, [bx]
    mov dx, cx
    dec dx
    check:
        cmp dx,0
        jb over
        mov bx, dx
        mov bl, [bx]
        cmp bl, al
        jbe over
        mov ah, bl 
        mov bx, dx
        mov [bx]+1, ah
        dec dx
        jmp check
    over:
    mov bx, dx
    mov [bx] + 1, al
    inc cx
    cmp cx, 1019h
    jb mainLoop

 

mov ah, 4ch  
int 21h
MAIN endp
END MAIN




