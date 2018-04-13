TITLE Assignment6.asm ; 
;Program Description:
;Caesar Encryption and Decryption
;Requires user to put in a string, and a key that 
;can also be changed
;THIS MUST BE DONE WITHOUT USING CALL WRITESTRING
;
;
;Author: AISHA QURESHI
;11/15/2017
Include Irvine32.inc

clearEAX TEXTEQU <mov EAX, 0> 
clearEBX TEXTEQU <mov EBX, 0> 
clearECX TEXTEQU <mov ECX, 0> 
clearEDX TEXTEQU <mov EDX, 0> 
clearEDI TEXTEQU <mov EDI, 0> 
clearESI TEXTEQU <mov ESI, 0> 

maxStringLength = 51d

.data
	UserOption BYTE 0h
	theStringLength BYTE ?					;String of word to crypt
	theString BYTE maxStringLength DUP (0)

	KeySize BYTE ? 							;Key length that user inputs
	KeyArray BYTE maxStringLength DUP (0)


.code
main PROC

;CLEAR REGISTERS
clearEAX									
clearEBX									
clearECX										
clearEDX										
clearESI										
clearEDI										

mov EDX, OFFSET theString						
mov ECX, lengthof theString
	
	startHere:										
		call DisplayMenu									
		call ReadHex										
		mov UserOption, AL								
							

	opt1:			;user enters option1 to enter a string to crypt						
		cmp UserOption, 1							
		jne Opt2				;if not = 1 jump to 3					
		call clrscr									
		mov ECX, maxstringlength					
		call Option1						
		mov theStringLength, AL 
		JMP startHere								

	opt2:			; user enters/changes a key to encrypt and encrypts string			
		cmp UserOption, 2								
		jne Opt3						; if not = 2 jump to 3				
		mov EBX, OFFSET KeyArray						
		movzx EAX, KeySize							
		movzx ECX, theStringLength						
		call Encrypt									
		mov KeySize, AL
		JMP startHere									


	opt3:				; user enters/changes a key to decrypt and decrypts string						
		cmp UserOption, 3									
		jne Opt4				;if not = 3 jump to 4
		mov EBX, OFFSET KeyArray							
		movzx EAX, KeySize							
		movzx ECX, theStringLength						
		call Decrypt								
		mov KeySize, AL
		JMP startHere								

	opt4:				;Quit program							
		cmp UserOption, 4								
		je quitit										
		call Oops																			
		JMP startHere									
quitit:	
exit
main endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayMenu PROC uses EDX
;Menu to display options for user
;Recieves and returns NOTHING 
.data
Menuprompt1 BYTE 'ENCRYPTION/ DECRYPTION MAIN MENU', 0Ah, 0Dh,
'==========================', 0Ah, 0Dh,
'1. Enter a String', 0Ah, 0Dh,
'2. Encrypt the String', 0Ah, 0Dh,
'3. Decrypt the String', 0Ah, 0Dh,
'4. Quit', 0Ah, 0Dh, 0h

.code
call clrscr									
mov EDX, Offset Menuprompt1							
call WriteString								
ret											
displayMenu ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Option1 PROC uses ECX
;Allows user to enter a string that'll be crypted
;Recieves address/ofset and maxStringLength of the string
;Returns string inputted by user
.data
userPrompt1 byte "enter your string --> ", 0

.code
push EDX												
mov EDX, Offset userPrompt1							
call writeString										
pop EDX												
call ReadString										

mov ECX, EAX										
Call CharOnly	;call procedure to remove nonletters								
mov ECX, EBX								
mov EAX, EBX									
push EAX										
clearEDI									
Call ChangeCase	;call procedue to make lower case to upper 							
pop EAX											

ret
Option1 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KeyInput PROC uses ECX
;Allows user to input key to decide how much to crypt
;Recieves: ofset of keysize and KeyArray 
;Returns user inputted key
.data
KeyPrompt byte "enter your key --> ", 0

.code
push EDX										
mov EDX, Offset KeyPrompt						
call writeString						
pop EDX								
call ReadString										
mov ECX, EAX									
push EAX							
clearEDI									
Call ChangeCase	;call proc to change lower to uppercase			
pop EAX										

ret
KeyInput ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ChangeCase Proc uses EDI ECX EDX 
;convert lower to uppercase
;recieves: string offset
;returns: uppercase letter string
.data

.code
Caseloop:											
	mov al, byte ptr [EDX+EDI]							
	cmp al, 41h										
	jb keepgoing										
	cmp al, 5Ah									
	jbe keepgoing									
	sub al, 20h									
	mov byte ptr [EDX+EDI], al 					
	keepgoing:									
		inc EDI							
loop Caseloop							

ret												
ChangeCase ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Encrypt PROC uses EBX EDX ECX EDI ESI
;Caesar encryption using a inputted key 
;receives: sting of word to be crypted and key
;returns NOTHING
.data
ChangeKey BYTE  'Do you want to change your key?', 0Ah, 0Dh,
'1. yes', 0Ah, 0Dh,
'2. no', 0Ah, 0Dh, 0h
NewKey byte ?		;if user wants to enter new string

.code
mov EDI, 0 
mov esi, 0
call clrscr

push EAX												
mov EAX,[EBX+0]										
cmp EAX,0												
push EDX										
je YesChangeKey			;enter key if this is the first time						

Begin:											
	mov EDX, OFFSET ChangeKey									
	call WriteString									
	call ReadHex										

	cmp al, 1					;if 1 jump to change key							
	je YesChangeKey										
	cmp al,2					;if 2 jump to dont change key		
	je DontChangeKey												
	call Oops					; else display error message							
	JMP Begin									

YesChangeKey:									
	pop EDX											
	pop EAX										
	push EDX								
	push ECX												
	mov EDX, EBX									
	mov ECX, 51d		;mov maxlength to counter			
	call KeyInput					
	mov NewKey, al								
	pop ECX								
	JMP Complete						
DontChangeKey:				;let key be the same							
	pop EDX										
	pop EAX											
	push EDX											
	mov NewKey, al									
Complete:											
	pop EDX											
	movzx EAX, NewKey								
	push EAX											
	push ECX									
LoopEn:				;encrypt string in a loop					
	push EAX
	Begin1:										
		cmp EDI, EAX									
		je zeroEDI										
		movzx EAX, Byte PTR [EBX+EDI]							
		push EBX										
		mov bl, 26d		;mod base 26 to see how far to shift in the ascii table	
		div bl										
		add [EDX+ESI],AH										
		movzx EAX,Byte PTR [EDX+ESI]								
		cmp EAX,5Ah											
		JA Restore			;if greater than Z, jump 							
		JMP Done								 
	zeroEDI:											
		Mov EDI, 0							
		JMP Begin1	 
	Restore:											
		sub EAX, 26d ; add 26 to key	
	done:								
	mov [EDX+ESI], AL								
	pop EBX												
	pop EAX											
	INC EDI										
	INC ESI								
Loop LoopEn									

pop ECX
mov ESI, 0											
call clrscr											
call Format		;format to xxxxx xxxxx									
call crlf											
pop EAX											
call waitmsg									

ret											
Encrypt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Decrypt PROC uses EDI ESI
;Caesar decryption using a inputted key 
;receives: sting of word to be crypted and key
;returns NOTHING
.data
ChangeKey2 BYTE  'Do you want to change your key?', 0Ah, 0Dh,
'1. yes', 0Ah, 0Dh,
'2. no', 0Ah, 0Dh, 0h
NewKey2 byte ?

.code
mov EDI, 0 
mov esi, 0 
call clrscr

push EAX												
mov EAX,[EBX+0]									
cmp EAX, 0											
push EDX										
je YesChangeKey2			;enter key if this is the first time							
Begin00:									
	mov EDX, OFFSET ChangeKey2								
	call WriteString									
	call ReadHex									
	cmp al, 1					;if one change key to something else 				
	je YesChangeKey2			;jump to yeschangekey							
	cmp al, 2					;if 2 do not change key							
	je DontChangeKey2										
	call Oops									
	JMP Begin00		

YesChangeKey2:		;edit key							
	pop EDX											
	pop EAX							
	push EDX												
	push ECX								
	mov EDX, EBX								
	mov ECX, 51d			
	call KeyInput								
	mov NewKey2, al					
	pop ECX											
	JMP Completed					
DontChangeKey2:	;let key be the same
	pop EDX							
	pop EAX					
	push EDX									
	mov NewKey2, al								
Completed:								
	pop EDX								
	movzx EAX, NewKey2								
	push EAX									
	push ECX										
LoopDe:			;decrypt string in loop							
	push EAX											
	Begin11:											
		cmp EDI, EAX											
		je zeroEDI2									
		movzx EAX, Byte PTR [EBX+EDI]							
		push EBX						
		mov bl, 26d		;mod base 26 to see how far to shift in the ascii table	
		div bl						
		sub [EDX+ESI],AH								
		movzx EAX,Byte PTR [EDX+ESI]				
		cmp EAX, 41h									
		JB Restore2	;if less than A, jump							
		JMP Done2								
	zeroEDI2:									
		clearEDI	;clear edi register							
		JMP Begin11		
	Restore2:						
		add EAX, 26d	;add 26 							
	Done2:									
		mov [EDX+ESI], AL								
		pop EBX								
		pop EAX							
		INC EDI							
		INC ESI								
Loop LoopDe									

pop ECX
mov ESI, 0								
call clrscr
call Format		;format result xxxxx xxxxx					
call crlf							
pop EAX
call waitmsg							

ret								
Decrypt ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Format PROC uses ESI ECX EDX
;print string formatted 5letters SPACE 5letters XXXXX XXXXX
;Recieves: string and the length
;Return: NOTHING
.data

.code
Loop1:												
	cmp ECX, 5d		;if ecx= 5 letters, go to loop. 							
	jb tooLittle	;if less than five then jump to tooLittle								
	push ECX									
	Mov ECX, 5d											

	Loop2:							;print characters in a loop			
		mov EAX, Dword ptr [EDX + ESI]						
		call WriteChar											
		Inc ESI											
	LOOP Loop2
										
	mov EAX,20h		;ascii for space = 20h to eax register									
	call WriteChar										
	JMP Continue								

	tooLittle:		;print out characters that are less than 5							
		mov EAX, Dword ptr [EDX + ESI]						
		call WriteChar											
		Inc ESI												
		JMP Finish											
	Continue:											
		pop ECX												
		Sub ECX, 4d												
	Finish:												
		Loop Loop1											
ret													
Format ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearString PROC USES EDX ECX ESI 
;Description: Clears a byte array given offset in EDX and length in ECX 
;Receives: Offset of string to be cleared in EDX
;          length of string to be cleared in ECX
;Returns: nothing

;// increment through the passed array and set every element to zero
clearESI
ClearIt:
mov byte ptr [EDX + ESI], 0
inc ESI
loop ClearIt

ret
ClearString ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CharOnly PROC USES ECX EDX ESI
;// Description:  Removes all non-letter elements 
;// Receives:  ECX - length of string
;//            EDX - offset of string
;//            EBX - offset of string length variable
;//            ESI preserved
;// Returns: string with all non-letter elements removed

.data
tempstr BYTE 50 dup(0)      ;// hold string while working - 

.code
;// preserve edx, ecx
push EDX
push ECX

;// clear tempstr for repeated calls from main
mov EDX, offset tempstr
mov ECX, 50
call ClearString

;// restore ecx, edx
pop ECX
pop EDX


push ecx						;// save value of ecx for next loop
clearEDI						;// use edi as index to step through the string										
L3:
mov al, byte ptr [EDX + ESI]		;// grab an element of the string			

;// check to see if the element is a letter.  
cmp al, 5Ah
ja lowercase										;// if above 5Ah has a chance of being lowercase
cmp al, 41h										;// if below 41h will not be a letter so skip this element
jb skipit
jmp addit											;// otherwise it is a capital letter and should be added to our temporary string

lowercase:
cmp al, 61h     
jb skipit											;// if below then is not a letter but is in the range 5Bh and 60h
cmp al, 7Ah										;// if above then it is not a letter, otherwise it is a lowercase letter
ja skipit

addit:											;// if determined to be a letter, then it must be added to the temp string
mov tempstr[edi], al
inc edi											;// move to next element of theString
inc esi											;// move to next element of temp string
jmp endloop										;// go to the end of the loop

skipit:											;// skipping the element 
inc esi											;// go to next element of theString

endloop:
loopnz L3

mov ebx, edi										;// updates length of string

pop ecx											;// restores original value of ecx for the next loop

;// copies the temp string to theString will all non-letter elements removed
clearEDI
L3a:     
mov al, tempstr[edi]
mov byte ptr [edx + edi], al
inc edi
loop L3a


ret
CharOnly ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Oops Proc USES EDX EBX
.data
Caption BYTE "*** Error ***",0
OopsMsg BYTE "You have chosen an invalid option!", 0ah, 0dh, 0

.code
mov EBX, Offset Caption									
mov EDX, offset OopsMsg								
call MsgBox											
ret													
Oops ENDP

end main  ;end ofsource code