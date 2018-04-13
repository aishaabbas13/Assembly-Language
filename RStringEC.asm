TITLE RStringEC.asm
; Program Description
;	
;UserInt:
;	Asks for an unsigned integer input (N) from a user.
;	pass this integer back to the calling procedure as an argument
;
;RandStr:
;	Create N Strings of random CAPITAL letters  
;	The length of the string ranges from 5 to 25 letters
;	AND the strings must all be unique from each other
;
;setColor:
;	Procedue to change the colors of the test in the console window
;	The colors are randomly generated
;
; Author: Aisha Qureshi
; Creation Date: 10/13/2017


Include Irvine32.inc

	;text macro to clear the registers
		clearEAX TEXTEQU <mov EAX, 0>
		clearEBX TEXTEQU <mov EBX, 0>
		clearECX TEXTEQU <mov ECX, 0>
		clearEDX TEXTEQU <mov EDX, 0>
	

.data
	; declare variables here
	str1 BYTE "Enter an Unsigned Integer. " ,0 ;String Output of what the user should input
	N DWORD ?	;User input for how many strings to create
	
	Array1 BYTE 25 DUP (?)  ;ArraySize is can be 25 letters long
	
	
.code
main proc
	;clears registers
		clearEAX
		clearEBX
		clearECX
		clearEDX
	
	;call procedures into main	
		call UserInt
		Call RandStr
		
exit
main endp	;end of main procedure		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UserInt proc				
	mov edx, OFFSET str1	;get address of the string of my output
	call WriteString		;prints str1 to screen
	call Crlf				;end of line
	call ReadDec			;reads in a 4 byte unsigned integer into the program that the user input (N)
							;N is called upon and stored in EAX
	mov ecx, eax			;Move eax into the ecx to know how many strings should be created in the loop
ret	
UserInt endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RandStr proc				;will contain nested loops
	L1:						;generate the string of random letters
	push ecx				;save the value of ECX into the Stack
	mov eax, 21d			;make the range of numbers on the string go up to 21
	call RandomRange		;create random integers and will be stored in eax 
	add eax, 5d				;range of string length must be 5 to 25 and to set that bound we add 5 to 21
	mov ecx, eax			;move the integers into ecx
	mov eax, OFFSET Array1	;grab the address of Array1 and move to eax
	push ecx				;save the value of ecx to be used in L2 to stack
	
	L2:						;generate the letter of each string
	push eax				;save address string in stack
	mov eax, 26d			;move range of the string of letters to eax
	call RandomRange		
	add eax,'A'				;'A' is moved to eax that holds the random integers created by RandomRange
	mov ebx, eax			;move eax to ebx
	pop eax					;pop off address of string of eax from stack
	mov [EAX], bl			;move bl into elements of Array1
	inc eax					;increase by 1 so it can move on to the next element
	loop L2					;end loop L2
	
	mov eax, OFFSET Array1	;move address of Array 1 to eax
	pop ecx					;pop off integer from ecx( the counter)


	L3:						;prints each letter of the string
	mov bl, [eax]			; move value to bl
	push eax				;save address of string of eax
	mov eax, ebx			;move back to eax
	call WriteChar			;prints letter
	pop eax					;pop off address
	inc eax					;increase to the next letter
	loop L3					;End loop L3
		
	pop ecx					;pop off N from the stack for the amount of string and goes to the next string
	call setColor			;Call procedure to change color of texts
	call crlf				;endd line
	loop L1					;end loop L1

ret
RandStr endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setColor proc

	mov eax, 15d		;move all text colors to eax
	call RandomRange	;generate random colors
	add eax, 1d			;because black=0 so if it's increased by one it will never be zero
	call SetTextColor	;call the setter for text fore/background color

ret
setColor endp

end main	;end of source code