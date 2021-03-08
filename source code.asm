;This is COM File Which means combine between data segment and code segment
.MODEL SMALL
.CODE
ORG               100H
START:            JMP START_PROG

CURSOR_POINT        DB        ">> $"
BREAK_SPACE         DB        0AH,0DH,"$"
START_MSG_1         DB        "                  #######################################",0AH,0DH,"$"
START_MSG_2         DB        "                  #-------------------------------------#",0AH,0DH,"$"
START_MSG_3         DB        "                  #-----------Assembly project----------#",0AH,0DH,"$"
START_MSG_4         DB        "                  #------Intel Architecture, 32-bit-----#",0AH,0DH,"$"
START_MSG_5         DB        "                  #######################################",0AH,0DH,0AH,0DH,"$"

OVERWRITEMSG0       DB        "                 ... XSSX DIRECTED BY A.K.A TEAM XSSX .... $"
LIST_ARGS           DB        "Choose your option.Note:keep in mind the file name must be 8 characters'File.txt', for this program",0AH,0DH,"$"
ARGUMENT_1          DB        "1- Delete File.",0AH,0DH,"$"
ARGUMENT_2          DB        "2- Overwrite file Content & Damage the file, if it image or video",0AH,0DH,"$"
ARGUMENT_3          DB        "3- Encrypt file Content by XOR and change extension file from File.txt File.BAK",0AH,0DH,"$"
ARGUMENT_4          DB        "4- Decrypt file Content by XOR and change extension file from File.BAK File.txt",0AH,0DH,"$"
ARGUMENT_5          DB        "5- SHUTDOWN OS.",0AH,0DH,"$"
ARGUMENT_6          DB        "6- Show MOUSE POINTER",0AH,0DH,"$"
ARGUMENT_7          DB        "7- Hide MOUSE HIDDEN",0AH,0DH,"$"
ARGUMENT_8          DB        "8- Reposition Mouse pointer every part of second .Note:please press 6 to show pointer before use service 8",0AH,0DH,"$"

MAXSIZE             DB        50
COUNT               DB        ?
BUFFER              DB        50 DUP(?)
HANDLE              DW        ?
ASK_DEL_FILE        DB        "Please Enter The name of File to delete: $"
ASK_OVR_FILE        DB        "Please Enter The name  of File to modify: $"
ASK_HIDDEN_FILE     DB        "Please Enter The File to HIDDEN: $"
;Handling Errors
F_N_F_E_MSG         DB        "File is not found. $"
P_N_F_E_MSG         DB        "Path is not found. $"
ACS_D_E_MSG         DB        "Access Denied. $"
INSUF_M_E_M         DB        "Insufficient Memory. $"
ALL_IS_OK_M         DB        "Deleted Successfully. $"
ALL_IS_OK_TWO       DB        "Overwrite & Damage Successfully. $"
OVERWRITEMSG        DB        " ... X$$X DIRECTED BY A.K.A TEAM X$$X ..... $"

;Encrption Variables
max                 DB        9
read                DB        ?
file1               DB        8 dup(0)
zero                DB        0
file2               DB        4 dup(0),".BAK",0
h1                  DW        0
h2                  DW        0
prompt              DB        "PLEASE ENTER THE FILE TO ENCRYPT",0AH,0DH,"$"
             
;Decryption Varibles
max_Decrypt db 9
read_Decrypt db ?
file1_Decrypt db 8 dup(0)
zero_Decrypt db 0
file2_Decrypt db 4 dup(0),".txt",0
 h1_Decrypt dw 0
 h2_Decrypt dw 0
prompt_Decrypt db "PLEASE ENTER THE NAME OF FILE TO DECRYPT",0AH,0DH,"$"



START_PROG PROC NEAR
;<==============PRINTING PROGRAM STARTING=================>;

    MOV DX, OFFSET BREAK_SPACE
    MOV CX, 10
  FRST_BREAK:
    CALL PRNT_STRING
    LOOP FRST_BREAK

    MOV DX, OFFSET START_MSG_1
    CALL PRNT_STRING
    MOV DX, OFFSET START_MSG_2
    CALL PRNT_STRING
    MOV DX, OFFSET START_MSG_3
    CALL PRNT_STRING
    MOV DX, OFFSET START_MSG_4
    CALL PRNT_STRING
    MOV DX, OFFSET START_MSG_5
    CALL PRNT_STRING
    MOV DX, OFFSET OVERWRITEMSG0
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE

    MOV DX, OFFSET BREAK_SPACE
    MOV CX, 3
  SECD_BREAK:
    CALL PRNT_STRING
    LOOP SECD_BREAK

;<===================PRINTING BANNER=======================>;

    MOV DX, OFFSET LIST_ARGS
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    MOV DX, OFFSET ARGUMENT_1
    CALL PRNT_STRING
    MOV DX, OFFSET ARGUMENT_2
    CALL PRNT_STRING
    MOV DX, OFFSET ARGUMENT_3
	CALL PRNT_STRING
	MOV DX, OFFSET ARGUMENT_4 
    CALL PRNT_STRING
   
	  MOV DX, OFFSET ARGUMENT_5
    CALL PRNT_STRING
	  MOV DX, OFFSET ARGUMENT_6
    CALL PRNT_STRING
	  MOV DX, OFFSET ARGUMENT_7
    CALL PRNT_STRING
	  MOV DX, OFFSET ARGUMENT_8
    CALL PRNT_STRING
	  MOV DX, OFFSET CURSOR_POINT
    CALL PRNT_STRING

;<===============Selcet your choice from menu====================>;

    MOV AH,1H
    INT 21H             ; DATA WILL STORED IN 'AL'
    CMP AL, '1'
    JNE CMP_2
    CALL DELETE_FILE
  CMP_2:
    CMP AL, '2'
    JNE CMP_3
    CALL OVERWRITE_CONT
  CMP_3:
    CMP AL, '3'
    JNE CMP_4
    CALL ENCRPT_FILE
	
	 CMP_4:
    CMP AL, '4'
    JNE CMP_5
    CALL Dycrept_FILE

  CMP_5:
    CMP AL,'5'
	JNE CMP_6
	CALL SHUTDOWN

  CMP_6:
    CMP AL,'6'
    JNE CMP_7
    CALL HARDWARE

  CMP_7:
    CMP AL,'7'
    JNE CMP_8
    CALL HARDWARE2

  CMP_8:
   CMP AL,'8'
   JNE END_OF_PROG
   CALL MOUSE_VIRUSE
;<===================END THE PROGRAM==========================>;
  END_OF_PROG:
    MOV AH, 4CH
    INT 21H
START_PROG ENDP

;<==========================DELETE FILE=========================>;
DELETE_FILE PROC
    PUSH AX
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    MOV DX, OFFSET ASK_DEL_FILE
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    CALL INSERT       ; PATH STORED AT 'BUFFER'
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    MOV BX, OFFSET BUFFER
    ADD BL, COUNT
    ADC BH, 0           ; I'M STOP ON 'ENTER' POINT
    MOV BYTE PTR [BX], 0; CHANGE 'ENTER' TO 0
    MOV AH,41H          ; DELETE THE FILE CHOOSEN
    MOV DX, OFFSET BUFFER
    INT 21H             ; EXCEPTION RETURNED IN 'AX'
    CALL ALL_IS_WELL
    POP AX              ; START PROGRAM'S AX[AH, AL('1')]
    RET                 ; RETURN TO START_PROG
DELETE_FILE ENDP

;<===================Errors files===================>;

ALL_IS_WELL PROC
    CMP AX, 2
    JE F_N_F_E
    CMP AX, 3
    JE P_N_F_E
    CMP AX, 5
    JE ACS_D_E
    CMP AX, 8
    JE INSUF_M_E
    JMP ALL_IS_OK
  F_N_F_E:
    MOV DX, OFFSET F_N_F_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW
  P_N_F_E:
    MOV DX, OFFSET P_N_F_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW
  ACS_D_E:
    MOV DX, OFFSET ACS_D_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW
  INSUF_M_E:
    MOV DX, OFFSET INSUF_M_E_M
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW
  ALL_IS_OK:
    MOV DX, OFFSET ALL_IS_OK_M
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
  END_AIW:
    RET                 ; RETURN TO DELETE_FILE
ALL_IS_WELL ENDP


ALL_IS_WELL_OVER PROC
    CMP AX, 2
    JE F_N_F_E_O
    CMP AX, 3
    JE P_N_F_E_O
    CMP AX, 5
    JE ACS_D_E_O
    CMP AX, 8
    JE INSUF_M_E_O
    JMP ALL_IS_OK_O
  F_N_F_E_O:
    MOV DX, OFFSET F_N_F_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW_O
  P_N_F_E_O:
    MOV DX, OFFSET P_N_F_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW_O
  ACS_D_E_O:
    MOV DX, OFFSET ACS_D_E_MSG
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW_O
  INSUF_M_E_O:
    MOV DX, OFFSET INSUF_M_E_M
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    JMP END_AIW_O
  ALL_IS_OK_O:
    MOV DX, OFFSET ALL_IS_OK_TWO
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
  END_AIW_O:
    RET                 ; RETURN TO DELETE_FILE
ALL_IS_WELL_OVER ENDP

;<===================Insert The name of file======================>;

INSERT PROC
    MOV DX, OFFSET CURSOR_POINT
    CALL PRNT_STRING
    MOV DX, OFFSET MAXSIZE
    MOV AH, 0AH
    INT 21H
    RET                 ; RETURN TO DELETE_FILE
INSERT ENDP

;<=====================PRINTING======================>;

PRNT_STRING PROC
    PUSH AX
    MOV AH, 9H
    INT 21H
    POP AX
    RET
PRNT_STRING ENDP

;<===================OVERWRITE======================>;

OVERWRITE_CONT PROC
    PUSH AX
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    MOV DX,OFFSET ASK_OVR_FILE
    CALL PRNT_STRING
    MOV DX, OFFSET BREAK_SPACE
    CALL PRNT_STRING
    MOV DX, OFFSET CURSOR_POINT
    CALL PRNT_STRING
	;READ FILE NAME
    MOV DX,OFFSET MAXSIZE
    MOV AH,0AH
    INT 21H
	;DETERMINED BY 0
    MOV BX,OFFSET BUFFER
    ADD BL,COUNT
    ADC BH,0H
    MOV BYTE PTR [BX],0
	;MAKE THE FILE OPEN AND FOR WRITE ONLY
    MOV DX,OFFSET BUFFER
    MOV AX,3D01H          ; OPEN FILE WITH HANDLE AND MAKE IT FOR WRITE ONLY
    INT 21H
    MOV HANDLE,AX         ; PUT THE HANDLE IN VARIABLE CALLED HANDLE
	;OVERWRITE & DAMAGE
	  MOV AH,40H            ; service for writing to a file
    MOV BX,HANDLE         ; TO POINTER ON FILE
    MOV CX,50      ; NUMBER OF BYTES
    MOV DX, OFFSET OVERWRITEMSG  ; BUFFER OF OVERWRITE
    INT 21H
	;CLOSE FILE
    MOV AH,3EH
    MOV BX,HANDLE         ; TO POINTER ON FILE
    INT 21H
	  CALL ALL_IS_WELL_OVER
    POP AX
    RET
OVERWRITE_CONT ENDP

;<===================ENC & DEC using XOR=======================>;
;Encryption
ENCRPT_FILE PROC
    mov dx,offset prompt
    mov ah,9h
    int 21h
;enter the file name
    mov dx ,offset max
    mov ah,0ah
    int 21h
    mov zero,0
;copy the name of file
    mov cx,4
    mov si,offset file1
    mov di,offset file2
    rep movsb
;open file one
    mov dx,offset file1
    mov ax,3D00h
    int 21h
    mov h1,ax
;create file two
    mov dx,offset file2
    mov ah,3Ch
    mov cx,0
    int 21h
    mov h2,ax
  yy:
;read file
    mov ah,3Fh
    mov cx,60*1024
    mov dx,offset our_data
    mov bx,h1
    int 21h
    cmp ax,0
    je xx
    mov  si, offset our_data
    mov cx,ax
  enc:
    XOR byte ptr [si],'p'
    inc si
    loop enc
;write on file
    mov cx ,ax
    mov ah,40h
    mov bx,h2
    int 21h
    jmp yy
;close files
  xx:
    mov ah,3eh
    mov bx,h1
    int 21h
    mov ah,3eh
    mov bx,h2
    int 21h
	
    int 20h
ENCRPT_FILE ENDP
;Decryption
Dycrept_FILE PROC
mov dx,offset prompt_Decrypt
mov ah,9h
int 21h
;enter the file name
mov dx ,offset max_Decrypt 
mov ah,0ah
int 21h 
mov zero_Decrypt,0
;copy the name of file 
mov cx,4
mov si,offset file1_Decrypt
mov di,offset file2_Decrypt
rep movsb
;open file one
mov dx,offset file1_Decrypt
mov ax,3D00h
int 21h
mov  h1_Decrypt,ax
;create file two
mov dx,offset file2_Decrypt
mov ah,3Ch
mov cx,0
int 21h 
mov  h2_Decrypt,ax
yy_D:
;read file
mov ah,3Fh
mov cx,60*1024
mov dx,offset our_data
mov bx, h1_Decrypt
int 21h
cmp ax,0
je xx_D
mov  si, offset our_data
mov cx,ax
DECrypt:
 XOR byte ptr [si],'P'
inc si
loop DECrypt
;write on file
mov cx ,ax
mov ah,40h
mov bx, h2_Decrypt
int 21h
jmp yy_D
;close files
xx_D:
mov ah,3eh
mov bx,h1_Decrypt
int 21h
mov ah,3eh
mov bx,h2_Decrypt
int 21h

int 20h 

Dycrept_FILE ENDP

;<===================SHUTDOWN======================>;

SHUTDOWN PROC
    INT 19H
    RET
SHUTDOWN ENDP

;<===================MOUSE=======================>;
;Show mouse pointer
HARDWARE PROC
    MOV AX,1
    INT 33H
    RET
HARDWARE ENDP
;Hide Mouse pointer
HARDWARE2 PROC
    MOV AX,2
    INT 33H
    RET
HARDWARE2 ENDP
;Reposition Mouse pointer every part of second 
MOUSE_VIRUSE PROC
    MOV AX, 4
  LOOP_VIRUS:
    MOV CX,600  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,100  ;X
    MOV DX,200  ;Y
    INT 33H
    CALL DELAY
    MOV CX,400  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,50  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,600  ;X
    MOV DX,400  ;Y
    INT 33H
    CALL DELAY
    MOV CX,100  ;X
    MOV DX,200  ;Y
    INT 33H
    CALL DELAY
    MOV CX,500  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,600  ;X
    MOV DX,300  ;Y
    INT 33H
    CALL DELAY
    MOV CX,300  ;X
    MOV DX,300  ;Y
    INT 33H
    CALL DELAY
    MOV CX,600  ;X
    MOV DX,150  ;Y
    INT 33H
    CALL DELAY
    MOV CX,150  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,50  ;X
    MOV DX,400  ;Y
    INT 33H
    CALL DELAY
    MOV CX,600  ;X
    MOV DX,600  ;Y
    INT 33H
    CALL DELAY
    MOV CX,400  ;X
    MOV DX,50  ;Y
    INT 33H
    MOV CX,200  ;X
    MOV DX,300  ;Y
    INT 33H
    CALL DELAY
    MOV CX,300  ;X
    MOV DX,300  ;Y
    INT 33H
    CALL DELAY
    MOV CX,400  ;X
    MOV DX,150  ;Y
    INT 33H
    CALL DELAY
    MOV CX,550  ;X
    MOV DX,50  ;Y
    INT 33H
    CALL DELAY
    MOV CX,300  ;X
    MOV DX,100  ;Y
    INT 33H
    CALL DELAY
    MOV CX,150  ;X
    MOV DX,100  ;Y
    INT 33H
    CALL DELAY
    MOV CX,250  ;X
    MOV DX,100  ;Y
    INT 33H
    CALL DELAY
    MOV CX,300  ;X
    MOV DX,100  ;Y
    INT 33H
    CALL DELAY
    MOV CX,200  ;X
    MOV DX,100  ;Y
    INT 33H
    CALL DELAY
    MOV CX,100  ;X
    MOV DX,100  ;Y
    INT 33H
    JMP LOOP_VIRUS
    RET
MOUSE_VIRUSE ENDP

;<===================DELAYING=======================>;

DELAY PROC
    PUSH CX
    MOV CX, 100*1024
  AGAIN:
    CMP CX, 0
    JE END_DELAY
    LOOP AGAIN
  END_DELAY:
    POP CX
    RET
DELAY ENDP
  our_data:
      END START
