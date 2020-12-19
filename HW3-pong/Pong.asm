STACK SEGMENT PARA STACK
    DB 64 DUP (' ')
STACK ENDS


DATA SEGMENT PARA 'DATA'
    
    WINDOW_W DW 140H
    WINDOW_H DW 0B0H 
     
    TIME_AUX DB 0
    
    BALL_OR_X DW 64H
    BALL_OR_Y DW 64H
     
    BALL_X DW 20H
    BALL_Y DW 20H
    
    BALL_SIZE DW 04H
    
    BALL_VEL_X DW 02H
    BALL_VEL_Y DW 03H  
                       
    WALL_LEFT_X DW 0AH
    WALL_LEFT_Y DW 1AH  
    
    WALL_UP_X DW 0AH
    WALL_UP_Y DW 1AH   
    
    WALL_DOWN_X DW 0AH
    WALL_DOWN_Y DW 0AFH
    
    WALL_W DW 05H
    WALL_H DW 05H  
    
    ROCKET_X DW 130H
    ROCKET_Y DW 2AH
    ROCKET_VEL DW 05H     
    
    SCORE DB 0d
    FINISH_FLAG DB 0H
    WIN_MSG DB 'YOU WIN!!! =) $'
    GAMEOVER_MSG DB 'GAME OVER :($'
    COLOR DB 0FH
    
    
DATA ENDS


CODE SEGMENT PARA 'CODE'
    
    MAIN PROC FAR
    ASSUME cs:CODE,ds:DATA,ss:STACK
    PUSH DS           
	SUB AX,AX                
	PUSH AX         
	MOV AX,DATA     
	MOV DS,AX   
	POP AX                              
	POP AX      
        
     CALL CLEAR_SCREEN
        checkTime:
            MOV AH, 2CH
            INT 21H
            
            CMP DL, TIME_AUX
            JE checkTime
        
            MOV TIME_AUX, DL
            
            CALL CLEAR_SCREEN
            
            CALL MOVE_BALL
            
            CALL CHECK_WIN
            MOV AL, FINISH_FLAG
            CMP AL, 1H
            JE FINISH_GAME
             
            
            
            CALL DRAW_BALL
            
            CALL DRAW_WALL
            
            CALL MOVE_ROCKET
            
            CALL  PRINT_SCORE  
            
            JMP checkTime
            
            FINISH_GAME:
             RET
    MAIN ENDP    
    
    DRAW_WALL PROC NEAR
        MOV CX, WALL_LEFT_X
        MOV DX, WALL_LEFT_Y
        
        LOOP_LEFT:
            MOV AH, 0CH 
            MOV AL, 0FH
            MOV BH, 00H
            INT 10H  
            
            INC CX
            MOV AX, CX
            SUB AX, WALL_LEFT_X
            CMP AX, WALL_W
            JNG LOOP_LEFT
            
            MOV CX,WALL_LEFT_X
            INC DX
            
            MOV AX, DX
            SUB AX, WALL_LEFT_Y
            ;CMP AX, WALL_H
            CMP DX, WINDOW_H
            JNG LOOP_LEFT    
            
            
        MOV CX, WALL_UP_X
        MOV DX,  WALL_UP_Y
        
        LOOP_UP:
            MOV AH, 0CH 
            MOV AL, 0FH
            MOV BH, 00H
            INT 10H  
            
            INC CX
            MOV AX, CX
            SUB AX, WALL_UP_X
            ;CMP AX, WALL_W
            CMP CX, WINDOW_W
            JNG LOOP_UP
            
            MOV CX, WALL_UP_X
            INC DX
            
            MOV AX, DX
            SUB AX, WALL_UP_Y
            CMP AX, WALL_H
            JNG LOOP_UP
            
                 
        MOV CX, WALL_DOWN_X
        MOV DX, WINDOW_H
        
        LOOP_DOWN:
            MOV AH, 0CH 
            MOV AL, 0FH
            MOV BH, 00H
            INT 10H  
            
            INC CX
            MOV AX, CX
            SUB AX, WALL_DOWN_X
            ;CMP AX, WALL_W
            CMP CX, WINDOW_W
            JNG LOOP_DOWN
            
            MOV CX,  WALL_DOWN_X
            DEC DX
            
            MOV AX, WINDOW_H
            SUB AX, DX
            CMP AX, WALL_H
            JNG LOOP_DOWN
            
            
            
       MOV CX,ROCKET_X 
	   MOV DX,ROCKET_Y
		
	   LOOP_ROCKET:
			MOV AH,0Ch 					
			MOV AL,COLOR 					
			MOV BH,00h 					
			INT 10h    					
			
			INC CX     					
			MOV AX,CX         			 
			SUB AX,ROCKET_X
			CMP AX,WALL_W
			JNG LOOP_ROCKET
			
			MOV CX,ROCKET_X		 
			INC DX       				 
			
			MOV AX,DX            	    
			SUB AX,ROCKET_Y
			CMP AX,1ah
			JNG LOOP_ROCKET
         
        
        
        RET
    dRAW_WALL ENDP
    
    MOVE_ROCKET PROC NEAR
        
        MOV AH, 01H
        INT 16H
        JZ FINISH 
        
        MOV AH,00H
        INT 16H
        
        CMP AL,77H
        JE MOVE_UP
               
        CMP AL,57H
        JE MOVE_UP
        
        CMP AL,73H
        JE MOVE_DOWN
               
        CMP AL,53H
        JE MOVE_DOWN
        
        MOVE_UP:
            MOV AX, WALL_UP_Y
            ADD AX, WALL_H
            CMP ROCKET_Y, AX
            JLE FINISH
            MOV AX, ROCKET_VEL
            SUB ROCKET_Y, AX
            RET    
            
        MOVE_DOWN:
            MOV AX, WINDOW_H
            SUB AX, WALL_H 
            SUB AX, 1AH
            CMP ROCKET_Y, AX
            JGE FINISH
            MOV AX, ROCKET_VEL
            ADD ROCKET_Y, AX
            RET
        
        FINISH:    
        RET    
    MOVE_ROCKET ENDP
    
    
    DRAW_BALL PROC NEAR
        MOV CX, BALL_X
        MOV DX, BALL_Y
        
        draw:
            MOV AH, 0CH 
            MOV AL, 0FH
            MOV BH, 00H
            INT 10H
            
            INC CX
            MOV AX, CX
            SUB AX, BALL_X
            CMP AX, BALL_SIZE
            JNG draw
            
            MOV CX, BALL_X
            INC DX
            
            MOV AX, DX
            SUB AX, BALL_Y
            CMP AX, BALL_SIZE
            JNG draw
        
        RET   
    DRAW_BALL ENDP   
        
        
        
    CLEAR_SCREEN PROC NEAR
        
        MOV AH, 00H 
        MOV AL, 13H
        INT 10H
            
        MOV AH, 00h
        MOV BH, 00H
        MOV BL, 00H
        INT 10H
        
        RET
    CLEAR_SCREEN ENDP
        
        
    
    MOVE_BALL PROC NEAR
         
        MOV AX, BALL_VEL_X 
        ADD BALL_X, AX
        
        
        MOV AX, WALL_LEFT_X
        ADD AX, WALL_W  
        CMP BALL_X, AX
        JL NEG_VEL_X
        
        MOV AX, WINDOW_W
        SUB AX, BALL_SIZE
        CMP BALL_X, AX
        JG RESET_BALL_LABEL
        
        ;;
        MOV AX, ROCKET_X
        CMP BALL_X, AX
        JGE CHECK 
        ;;
        
        MOV AX, BALL_VEL_Y
        ADD BALL_Y, AX  
        
        
        MOV AX, WALL_UP_Y
        ADD AX, WALL_H
        CMP BALL_Y, AX
        JL NEG_VEL_Y
        
        MOV AX, WINDOW_H
        SUB AX, BALL_SIZE
        CMP BALL_Y, AX
        JG NEG_VEL_Y
         
        RET
           
        NEG_VEL_X:
        NEG BALL_VEL_X
        RET
        
        NEG_VEL_Y:
        NEG BALL_VEL_Y  
        RET
        
        CHECK:
        MOV AX, ROCKET_Y
        CMP BALL_Y, AX
        JL RESET_BALL_LABEL
        ADD AX, 1aH
        CMP BALL_Y, AX
        JGE RESET_BALL_LABEL
        CALL ROCKET_COLOR  
        MOV AL, SCORE
        ADD AL, 1H
        MOV SCORE, AL
        CALL DISPLAY_LED
        JMP NEG_VEL_X        
        
        RESET_BALL_LABEL: 
        CALL GAME_OVER
        RET
        
    MOVE_BALL ENDP  
    
    
    
    PRINT_SCORE PROC NEAR 
    
        XOR DX,DX
        XOR CX,CX
        XOR AX,AX
        MOV AL , SCORE
        mov BX, 0AH 
    	div BX
        add AX, 48 
        add DX, 48
        MOV CL,AL
        MOV CH,DL
        
        mov  DL, 63H  
        mov  DH, 1H  
        mov  BH, 0   
        mov  AH, 02H 
        int  10H
        
        MOV DL, SCORE
        CMP DL, 0AH
        JL   HERE
        mov  DL, 63H 
        mov  AL, CL
        mov  BL, 0FH 
        mov  BH, 0  
        mov  AH, 0EH 
        int  10H    
        
        HERE:
        mov  DL, 64H 
        mov  DH, 1H  
        mov  BH, 0
        mov  AH, 04H
        int  10H
        
        mov  AL, CH
        mov  BL, 0FH 
        mov  BH, 0 
        mov  AH, 0EH
        int  10H
    
        RET
    PRINT_SCORE ENDP 

    CHECK_WIN PROC NEAR
        
        MOV AL, SCORE
        CMP AL, 30D
        JL CONTINUE
        
       mov AH, 00         ; set video mode 
    MOV AL,13H        ; graphic mode
    int 10h       
    
    MOV AH,00H
    MOV BH,01H
    MOV BL,00H    ;set backgroundcolor to black
    INT 10H 
    
        
    mov  dl, 14   ;Column
    mov  al, WIN_MSG
    MOV CX,  OFFSET WIN_MSG
    
    GO_AHEAD:
    ADD DL, 1
    mov  dh, 12   ;Row
    mov  bh, 0    ;Display page
    mov  ah, 02h  ;SetCursorPosition
    int  10h
    
    mov  bl, 0Ch  
    mov  bh, 1h  
    mov  ah, 0Eh
    int  10h
    ADD CX, 1H
    MOV BX, CX
    MOV AL, [BX]
    CMP AL, 36D
    JNE GO_AHEAD 
    MOV AL, 1H
    MOV FINISH_FLAG, AL    
        
        CONTINUE:
        RET    
    CHECK_WIN ENDP 
    
    GAME_OVER PROC NEAR
        
        mov AH, 00  
        MOV AL,13H
        int 10h       
    
        MOV AH,00H
        MOV BH,01H
        MOV BL,00H 
        INT 10H 
        
            
        mov  dl, 14  
        mov  al, GAMEOVER_MSG
        MOV CX,  OFFSET GAMEOVER_MSG
        
        AGAIN:
        ADD DL, 1
        mov  dh, 12  
        mov  bh, 0  
        mov  ah, 02h
        int  10h
        
        mov  bl, 0Ch  
        mov  bh, 1h  
        mov  ah, 0Eh
        int  10h
        ADD CX, 1H
        MOV BX, CX
        MOV AL, [BX]
        CMP AL, 36D
        JNE AGAIN
        MOV AL, 1H
        MOV FINISH_FLAG, AL
        
        RET
    GAME_OVER ENDP
    
    DISPLAY_LED PROC NEAR
        MOV AL , SCORE
        OUT 199 , AL     
 
        RET
    DISPLAY_LED ENDP
    
    ROCKET_COLOR PROC NEAR
       
       INJA:     
       MOV AH, 00h          
       INT 1AH         
    
       mov  ax, dx
       xor  dx, dx
       mov  cx, 010h    
       div  cx       
       CMP DL, 0H
       JE INJA
       
        mov color, dl
 
    RET
    ROCKET_COLOR  ENDP
    
    
CODE ENDS 
END