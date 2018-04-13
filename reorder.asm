TITLE reorder.asm
;Program Description
;	Rearrange the values of arrayD DWORD 312, 105, 21
;	into this order: 21, 312, 105
;	Using only MOV and XCHG
;
; Author: Aisha Qureshi
; Creation Date: 9/22/2017


Include Irvine32.inc

clearEAX TEXTEQU <mov EAX, 0>		;clear register eax

.data
	; declare variables here
	arrayD DWORD 312, 105, 21

.code
main proc
	; write your code here
	clearEAX
	mov EAX, arrayD			;move arrayD to eax reg
	XCHG EAX, [arrayD + 4]	;swaps 312 and 105
	XCHG EAX, [arrayD + 8]	;swaps 105 and 21
	mov arrayD, EAX			; mov register eax into arrayD
	call dumpRegs			;output
	
	exit
main endp		;end of main procedure
end main		;end of source code