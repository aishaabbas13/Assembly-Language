TITLE fibonacci.asm
; Program Description
;	Compute fib(n) for n = 2 to 6 using an array.
;	Use the fibonacci formula to determine the
;	values of the remainder of the elements
;	Store fib(2) to fib(6) in consecutive 
;	bytes of the ebx register starting from the lowest byte
;
; Author: Aisha Qureshi
; 09/22/2017



Include Irvine32.inc
	;clear registers 
	clearEAX TEXTEQU <mov eax, 0>
	clearEBX TEXTEQU <mov ebx, 0>
	clearECX TEXTEQU <mov ecx, 0>
	clearEDX TEXTEQU <mov edx, 0>
	clearESI TEXTEQU <mov esi, 0>

.data
	; declare variables here
	fib0 BYTE 0 ;variable given value 0
	fib1 BYTE 1	;variable given value 1
	arrayF BYTE 4 DUP (0) ;arrayF has 4 empty elements

	
.code
main proc
	; write your code here
	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	
	mov al, fib0				;0	
	add al, fib1				;0 + 1 = 1
	add al, fib1				;1 + 1 = 2
	mov arrayF, al				;moved to first element in arrayF 00000002
	
	XCHG fib1, al				;XCHG so that in line 35 it will be memory to reg
	add  al, fib1				;1 + 2 = 3
	mov [arrayF + 1], al		;moved to second element in arrayF 00000302

	XCHG fib1, al				;XCHG so that in line 39 it will be memory to reg
	add al, fib1				;3 + 2 = 5
	mov [arrayF + 2], al		;moved to third element in arrayF 00050302

	XCHG fib1, al				;XCHG so that in line 43 it will be memory to reg
	add al, fib1				;3 + 5 = 8
	mov [arrayF + 3], al		;moved to fourth element in arrayF 08050302

	mov esi, OFFSET arrayF		;creates byte size spaces through array elements
	mov ebx, [esi]				;move to ebx register


	call dumpRegs				;output


	exit
main endp
end main