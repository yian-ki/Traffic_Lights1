.model medium

.data 

.stack 
dw 128 dup (0)

.code   

DELAY:  ;input: CX, this value controls the delay. CX=50 means 1ms
        ;output: none
    	JCXZ @DELAY_END
    	@DEL_LOOP:
    	LOOP @DEL_LOOP	
    	@DELAY_END:
    	RET    
    	
time:    push cx
         mov cx,50000
         CALL DELAY
         pop cx
         loop time  
            
         ret  
         
         
all_red: mov al, 12h  
         out 60h, al
         out 62h, al 
         
         mov cx,5
         call time
         
         mov al, 09h  
         out 60h, al
         out 62h, al 
         
         mov cx,5
         call time 
         
         ret  
         
;crossing1: mov al, 12h
;           out 60h, al
;           
;           mov cx, 5
;           call time
;           
;           mov al, 09h
;           out 60h, al
;           
;           mov cx, 5
;           call time  
;           
;           ret
;           
;           
;           
;crossing2: mov al, 12h,
;           out 62h, al
;           
;           mov cx, 2
;           call time  
;           
;           mov al, 09h
;           out 62h, al
;           
;           mov cx, 3
;           call time
;           
;           ret
;            
           
         
emergency:
call all_red 

iret 

;cross:
;call crossing1
;
;iret
;
;cross1:
;call crossing2
;iret
; 
start:
;initialise data segment
mov ax,@data
mov ds,ax   

;initialise extra segment
mov ax, 00h
mov es, ax
             
;initialise 8255
mov al, 80h     ;10000000= 80h ;initialise portA
out 66h, al

;initialise 8259
mov al, 13h  ; ICW1 = 0001 0011 =13h
out 80h, al

mov al, 30h   ; ICW2 = 00110000 = 30h
out 82h, al

mov al, 03h    ;ICW4 =   00000011 = 03h
out 82h, al 

;interrupt vector table initialization
lea ax, emergency
mov di, 00c0h
stosw

mov ax, cs
stosw

STI    ;set interrupt flag  


 
lights:
;situation1:
;lighting R1 and R2
mov al, 09h     ;00_001_001
out 60h, al

;lighting G3 and G4
mov al, 24h     ;00_100_100    
out 62h, al   


mov cx, 5
call time
              
              
;situation2: 
;lightiing R1,Y1 and R2,Y2
mov al, 1bh    ;00_011_011
out 60h, al

;lighting Y3 and Y4
mov al, 12h   ;00_010_010
out 62h, al  


mov cx, 5
call time


;situation3:
;lighting G1 and G2
mov al, 24h    ;00_100_100
out 60h, al

;lighting  R3 and R4
mov al, 09h     ;00_001_001
out 62h, al   


mov cx, 5
call time

;situation4:
;lighting Y1 and Y2
mov al, 12h    ;00_010_010
out 60h, al

;lighting  R3,Y3 and R4, Y4
mov al, 1bh    ;00_011_011  
out 62h, al


mov cx, 5
call time
  
jmp lights  ;looping

hlt  

end start