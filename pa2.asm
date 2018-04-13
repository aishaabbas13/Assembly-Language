TITLE pa2.asm
; Program Description
;	Part 1: Single Statement that computes the
;			product Pi(i=2 to 8) i, i is an integer.
;	Part 2: a) Short block of computational statements
;				that causes the EBX register to overflow
;			b) Short block of computational statements that  
;				causes the ECX register to set the carry
;	Part 3: Using directives for creating symbolics, 
;			write a single statement that computes 
;			the number of seconds in a day.
;
; Author: Aisha Qureshi
; Creation Date: 9/13/2017


Include Irvine32.inc

	;text macro to clear the registers
		clearEAX TEXTEQU <mov EAX, 0>
		clearEBX TEXTEQU <mov EBX, 0>
		clearECX TEXTEQU <mov ECX, 0>
		clearEDX TEXTEQU <mov EDX, 0>
	
	;Part 1: multiplying 2 to 8 to get the product of Pi(i=2 to 8) i 
		Product EQU 2*3*4*5*6*7*8

	;Part 3: variables needed to find how many seconds in a day 
	hours = 24		;hours in a day
	minutes = 60	;minutes in an hour
	seconds = 60	;seconds in a minute

.data
	; declare variables here
	
	;Part 1: data definition
		Var1 WORD Product

	;Part 2a: Variables for oveflow (negative number >=8, positive number < 8) and SWORD because signed numbers
		OF1 SDWORD 0A0000000h	;10(negative number)
		OF2 SDWORD 90000000h	;9 (negative number)	

	;Part 2b: Variables for carry flag and DWORD because they are unsigned numbers
		CF1 DWORD 0A0000000h
		CF2 DWORD 90000000h

	; Part 3
		countSeconds TEXTEQU %(hours*minutes*seconds)	;assign const integer expression multiplying hours, minutes,
														;and seconds to countSeconds 
		SECONDS_IN_DAY TEXTEQU <mov EDX, countSeconds>	;text macro move countSeconds to EDX register and  
														;call it SECONDS_IN_DAY 

.code
main proc
	;clears registers
		clearEAX
		clearEBX
		clearECX
		clearEDX

	;Part 1 
		mov AX, Var1	;move to the EAX register, but in this case the AX register because EAX is too big
		call DumpRegs	;display

	;Part 2a
		mov EBX, OF1	; move OF1 to EBX register
		add EBX, OF2	;add OF2 to OF1 in the EBX register
						; 10+9 = 19 - 16 = 3(positive number) meaning it has been over flowed
		call DumpRegs	; display

	;Part 2b
		mov ECX, CF1	;move CF1 to the ECX register
		add ECX, CF2	;add CF2 to CF1 in the ECX register
						; 10 + 9 = 19 - 16 = 3 causing a carry flow
		call DumpRegs	; display

	;Part 3
		SECONDS_IN_DAY	;generates "mov EDX, 00015180" when assembled
						; 24*60*60 = 84000d = 15180h
		call DumpRegs	;display

	exit
main endp	;end of main procedure
end main	;end of source code