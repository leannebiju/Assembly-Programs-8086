DATA SEGMENT 
	msg1 DB "Enter the first number : $"
	msg2 DB 13,10, "Enter the second number : $"
	msg3 DB 13,10, "Result : $"
	res DB '00', '$'
	res1 DB '00', '$'
DATA ENDS

CODE SEGMENT 
	ASSUME CS:CODE, DS:DATA
	
	START:
		MOV AX, DATA
		MOV DS, AX
		
		;STORING THE FIRST NUMBER 
		LEA DX, msg1
		MOV AH, 09H
		INT 21H
		CALL GET_NUMBER
		MOV BL, CL
		MOV BH, CH
		
		;STORING THE SECOND NUMBER 
		LEA DX, msg2
		MOV AH,09H
		INT 21H
		CALL GET_NUMBER
		
		;MULTIPLY
		;UNITS POSITION OF TOP
		MOV AL,CL
		MUL BL
		MOV AH, 0
		CALL ADJUST ;TO ADJUST TO DECIMAL
		ADD AL, '0' ;THEN CONVERT TO ASCII 
		MOV res1[1], AL
		
		;TENS POSITION OF TOP
		MOV DH, AH ;MOVING CARRY TO DH
		MOV AL, CL 
		MUL BH     ;MULTIPLIED AND STORED TO AL
		ADD AL, DH ;ADDING CARRY TO RESULT
		MOV AH, 0
		CALL ADJUST
		
		;TENS POSITION OF BOTTOM 
		;AL HAS THE TENS POSITION OF TOP CURRENTLY AND AH CARRY
		MOV DL, AL ;STORING TO ADD LATER TO GET RES1[0] 
		MOV DH, AH ;STORING CARRY
		MOV AL, CH
		MUL BL
		ADD AL, DL ;ADDING TENS OF TOP AND BOTTOM
		MOV AH, 0
		CALL ADJUST
		ADD AL, '0'
		MOV res1[0], AL
		MOV DL, AH 
		
		;HUNDREDS OF BOTTOM
		MOV AL, CH
		MUL BH
		ADD AL, DL ;ADDING CARRY OF TENS ADDITION
		ADD AL, DH ;ADDING CARRY OF BH X CL 
		MOV AH, 0
		CALL ADJUST
		ADD AL, '0'
		MOV res[1], AL
		ADD AH, '0'
		MOV res[0], AH
		
		CALL DISPLAYRESULT
		
		MOV AH, 4CH
		INT 21H
		
	  GET_NUMBER:
    MOV AH, 01H
		INT 21H
		MOV CH, AL
		MOV AH, 01H
		INT 21H
		MOV CL, AL
		SUB CL, '0'
		SUB CH, '0'
		RET
	
	ADJUST:
		CMP AL,09H
		JBE ADJ
		SUB AL, 0AH
		INC AH
		JA ADJUST
		ADJ:
		RET
	
	DISPLAYRESULT:
		LEA DX, msg3
		MOV AH, 09H
		INT 21H
		LEA DX, res
		MOV AH, 09H
		INT 21H
		LEA DX, res1
		MOV AH,09H
		INT 21H
		RET

CODE ENDS 
END START
