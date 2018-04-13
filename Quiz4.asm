title Quiz4.asm
;Desc: Print ONLY Letter Grades in Color
;
;Aisha Qureshi
;11/02/2017


include irvine32.inc

.data

Grades dword 50 dup (0)
lenArray byte 0;


.code

main PROC

mov eax, 0
mov ebx, offset lenArray
call userInt

mov ebx, offset Grades
movzx ecx, lenArray
call FillArray


mov EBX, offset Grades
movzx ECX, lenArray
call Alphagrade
;call PrintGrade
;call waitmsg
mov ESI, 0
call AssignColor
movzx ecx, lenArray
call PrintCOLOR

;// Call to your procedures go here

exit
main ENDP

;// procedures

userInt PROC
;// Desc:  Gets an unsigned integer input from the user and places that value in a variable
;// Receives:  Offset of variable in EBX
;// Returns:  Nothing

.data
promptUser BYTE " Please enter a number <= 50 : ", 0h
oops BYTE "Invalid Entry.  Please try again.", 0h

.code
starthere:
   call clrscr
   mov edx, offset promptUser
   call writestring
   call readDec
cmp eax, 50d
ja tooBig
   mov [ebx], eax
ret

tooBig:
   mov edx, offset oops
   call writestring
   call waitmsg
jmp starthere

userInt ENDP

FillArray PROC
;// Desc:  Fills an array with a randomly generated numbers in the range 50 - 100
;// Receives:  Offset of a DWORD array in EBX
;//            Length of the Array in ECX
;// Returns:  Nothing

.code
mov esi, 1              ;// why is this 1? Hint:  It's not a mistake __________________________
call randomize

FillIt:
   mov eax, 51d
   call randomrange
   add eax, 50d            ;// what does this do? ______________________
   mov[ebx + esi], eax
   add esi, 4              ;// why can't we use TYPE here? _____________
loop FillIt
ret
FillArray ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Alphagrade PROC uses EBX ECX
;Desc: Puts a letter grade in bits 0-7  with colors set with letter grade when given an integer between 50 and 100 in bits 8-15
;Recieves: offset of array in ECX, length of array in EAX
;returns nothing

.code
;compare to find letter
;push letter into AL regiester

compareIt:
mov ESI, 1

mov AX, [EBX + ESI]
;compare scores to know where to jump
cmp al, 90d
JA GradeA
cmp al, 80d
JA GradeB
cmp Al, 70d
JA GradeC
cmp al, 60d
JA GradeD
cmp al, 59d
JBE GradeF


GradeA:	;if 90 or above jump here
	mov AL, 41h
	mov [EBX], AL	;putting "A" into the dereferenced BL
	add EBX, 4		;incrementing EBX to the next array value
	loop compareIt
	jmp endit
GradeB:	;80 to 89 jump here
	mov AL, 42h
	mov [EBX], AL
	add EBX, 4
	loop compareIt
	jmp endit
	
GradeC:	;70 to 79 jump here
	mov AL, 43h
	mov [EBX], AL	;putting "A" into the dereferenced BL
	add EBX, 4		;incrementing EBX to the next array value
	loop compareIt
	jmp endit

GradeD:	;60 to 69 jump here
	mov AL, 44h
	mov [EBX], AL
	add EBX, 4
	loop compareIt
	jmp endit

GradeF:	;50 to 59 jump here
	mov AL, 46h
	mov [EBX], AL	;putting "A" into the dereferenced BL
	add EBX, 4		;incrementing EBX to the next array value
	loop compareIt
	jmp endit
;loop compareIt

endit:

ret
AlphaGrade ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintGrade PROC uses EBX ECX
;Desc:prints the number in bits 8-15 the grade, and prints the cooresponding letter grade from bits 0-7 in color
;Takes EBX as offset of array; ECX as length of array
;Returns nothing

mov edx, 0
mov DL, 5	;column
mov DH, 1	;row

PrintLoop:
mov EAX, 0

mov ESI, 1
mov AL, [EBX+ESI]
call WriteDec	;print score
call GoToXY		;print row and column
mov eax, 28h	
Call WriteChar	;print (
mov EAX, [EBX]	
call WriteChar	;print grade letter
mov eax, 29h
call WriteChar	;print )
add DH, 1		;add another row
add EBX, 4		;increment to nect element

call crlf
loop PrintLoop

ret
PrintGrade ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AssignColor Proc uses EBX ECX
.code
;compare to find letter
;push letter into AL register

Loop2:
mov AL, BYTE PTR [EBX + ESI + 1]
cmp al, 90d
JA ColorA
cmp al, 80d
JA ColorB
cmp Al, 70d
JA ColorC
cmp al, 60d
JA ColorD
cmp al, 59d
JBE ColorF


ColorA:
	ROR DWORD PTR [EBX + ESI], 16	;rotate to upper half of DWORD
	mov eax, green + (black* 16)	;change color 
	mov BYTE PTR [EBX + ESI], Al	
	ROR DWORD PTR [EBX +ESI], 16	;Rotates back to lower half of DWORD
	jmp endit2
ColorB:
	ROR DWORD PTR [EBX + ESI], 16	;rotate to upper half of DWORD
	mov eax, green + (black* 16)	;change color
	mov BYTE PTR [EBX + ESI], AL
	ROR DWORD PTR [EBX +ESI], 16	;Rotates back to lower half of DWORD
	jmp endit2
	
ColorC:
	ROR DWORD PTR [EBX + ESI], 16	;rotate to upper half of DWORD
	mov eax, yellow + (black* 16)	;change color
	mov BYTE PTR [EBX + ESI], AL
	ROR DWORD PTR [EBX +ESI], 16	;Rotates back to lower half of DWORD
	jmp endit2

ColorD:
	ROR DWORD PTR [EBX + ESI], 16	;rotate to upper half of DWORD
	mov eax, black + (yellow* 16)	;change color
	mov BYTE PTR [EBX + ESI], AL
	ROR DWORD PTR [EBX +ESI], 16	;Rotates back to lower half of DWORD
	jmp endit2

ColorF:
	ROR DWORD PTR [EBX + ESI], 16	;rotate to upper half of DWORD
	mov eax, red + (black* 16)		;change color
	mov BYTE PTR [EBX + ESI], AL
	ROR DWORD PTR [EBX +ESI], 16	;Rotates back to lower half of DWORD
	jmp endit2


endit2:
	add ESI, 4		;incrementing EBX to the next array value
	loop Loop2

ret
AssignColor ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintCOLOR PROC uses EBX ECX
;Desc:prints the number in bits 8-15 the grade, and prints the cooresponding letter grade from bits 0-7
;Takes EBX as offset of array; ECX as length of array
;Returns nothing

mov ESI, 0
mov edx, 0
mov DL, 5		;column
mov DH, 1		;row

PrintLoop2:
mov EAX, 0

mov AL, BYTE PTR [EBX+ESI+1]
call WriteDec					;print score
call GoToXY
mov eax, 28h
call WriteChar					;print (
ROR DWORD PTR [EBX + ESI], 16	;rotate upper half of DWORD
mov AL, BYTE PTR [EBX + ESI]
call SetTextColor				;set the colors of the letter
ROR DWORD PTR [EBX + ESI], 16	;rotate back to lower half of DWORD
mov AL, BYTE PTR [EBX+ ESI]
call WriteChar					;print colored words
mov AL, lightGRAY+ (BLACK*16)	;change color back to lightgrey
call SetTextColor
mov eax, 29h					
call writeChar					;print )
add DH, 1						;add another row
add ESI, 4

call crlf
loop PrintLoop2
ret
PrintCOLOR ENDP
END main