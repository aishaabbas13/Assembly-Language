TITLE Quiz3.asm

;Program Description: print an array of size dword with A random integers from a range of j to k
;						j is less than k, k and j are less than 200, A is less than 20
;Aisha Qureshi
;10/23/2017

Include Irvine32.inc

		clearEAX TEXTEQU <mov EAX, 0>
		clearEBX TEXTEQU <mov EBX, 0>
		clearECX TEXTEQU <mov ECX, 0>
		clearEDX TEXTEQU <mov EDX, 0>
	
.data
	; declare variables here
	
	str1 byte "Enter an integer: ", 0
	str2 byte "What is the lowest integer?", 0
	str3 byte "What is the greatest integer?", 0
	str4 byte "A = ", 0
	str5 byte "j = ", 0
	str6 byte "k = ", 0
	str7 byte "The array is : " ,0
	
	wrongput byte "ERROR. Enter integers within the range", 0
	CodeEnd byte "Please Enter an integer where k is larger than j", 0
	
	ArrayL DWORD 20 DUP (?)	;20 element array
	
	;inputs of the user
	A DWORD ?
	j DWORD ?
	k DWORD ?
	
.code	
main proc
		clearEAX
		clearEBX
		clearECX
		clearEDX

		call UserInt

			
exit
main endp		
	
UserInt proc
.code

	mov edx, OFFSET str1	;move address of str1 to edx
	
	Wrong:						;jump here if out of range
	
	call WriteString			;print output
	call Crlf					;end of line
	call ReadDec				;print input
	cmp eax, 20					;compare with 20 because range of numbers should not be more
	jbe L1						; jump to L1 if below or equal to 20
	mov edx, offset wrongput	;move address of output to edx
	jmp Wrong					; else say it is wrong and ask for new input
	
	L1: 
	mov A, eax					;mov eax back to A
	
	mov edx, OFFSET str2		;move address of str2 to edx
	
	Wrong2:						;jump here if out of range
	
	call WriteString		
	call Crlf				
	call ReadDec			
	cmp eax, 200				;compare j to 200 because integer cannot be bigger than 200
	jbe L2						;jump to L2 if below or equal to 200
	mov edx, offset wrongput	
	jmp Wrong2					;else say it is wrong and ask fow new input

	L2:
	mov j, eax					;move eax back to j
	mov edx, OFFSET str3	
	
	Wrong3:
	call WriteString				
	call Crlf				
	call ReadDec			
	cmp eax, 200		;compare k to 200 because integer cannot be bigger than 200
	jbe L3				;jump to L3 if below or equal to 200
	jmp Wrong3			;else say it is wrong and ask fow new input
	
	L3:
			
	cmp eax, j			; compare j to k 
	ja CODE_End			;k is above j then move on
	mov edx, Offset CodeEnd
	jmp Wrong3			; else print error message
	
	CODE_End:
	mov k, eax			; move value in eax to k
	
	mov ecx, A
	mov esi, OFFSET ArrayL
	
	Loop1:
		mov eax, k		;move k to eax
		sub eax, j		;subtract j from k to get range from inputted number
		call RandomRange	;generate random numbers
		add eax, j			; add j back to eax
		mov [esi], eax		; move eax to dereferenced esi
		add esi, 4			; add 4 to increment but 1 because its dword
	loop Loop1
	
	;Print Display
		;a = ?
	mov edx, OFFSET str4
	mov eax, A	
	call WriteString	
	call WriteDec	
	call Crlf				
		;j = ?
	mov edx, OFFSET str5	
	mov eax, j
	call WriteString
	call WriteDec
	call Crlf				
		;k = ?
	mov edx, OFFSET str6
	mov eax, k	
	call WriteString
	call WriteDec		
	call Crlf		
		;the array is:
	mov edx, OFFSET str7	
	call WriteString
	call Crlf	
	
	;print final answer using dump regs
	mov esi, offset ArrayL
	mov ecx, A
	mov ebx, type ArrayL
	call DumpMem

	ret
UserInt endp

	
end main