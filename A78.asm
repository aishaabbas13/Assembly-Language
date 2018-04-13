Title A78.asm
;Program that finds the prime numbers
; between a range of numbers of 2 to 1000
;
;Aisha Qureshi
;12/04/2017


INCLUDE Irvine32.inc				

;text macro to clear the registers
clearEAX TEXTEQU <mov eax, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ecx, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov esi, 0>
clearEDI TEXTEQU <mov edi, 0>

.data
n DWORD ?	;user input for what number to find prime until
primeArray DWORD 1000 DUP(0)	;array of 1000 numbers and then remove composite numbers from the 1000 numbers			
primeCounter BYTE 0		;counts how many prime numbers are in the range			

;prototypes
displayMenu Proto
FindPrimes Proto
DisplayPrimes Proto	
UserInt Proto

.code
main proc
;clear registers
clearEAX
clearEBX
clearECX
clearEDX
clearESI
clearEDI

;INVOKES
INVOKE displayMenu
INVOKE FindPrimes
INVOKE DisplayPrimes
INVOKE UserInt	

Call displayMenu	;display menu to screen
Call waitMSG	

exit
main endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayMenu proc
;Show Menu of what the user wants to do to user
;Receives,Returns, Requires nothing

.data
;what to print to console window
menuPrompt BYTE "MAIN MENU", 0
menuDashes BYTE "----------", 0
userOption1 BYTE "1. Display all primes between 2 and 1000", 0
userOption2 BYTE "2. Display all primes between 2 and n", 0
userOption3 BYTE "3. Exit", 0


.code
;print menu the way as it is displayed in .data
startHere:
Call clrscr			
		
mov EDX, OFFSET menuPrompt 			
Call WriteString
Call crlf

mov EDX, OFFSET menuDashes			
Call WriteString
Call CRLF

mov EDX, OFFSET userOption1				
Call WriteString
Call crlf

mov EDX, OFFSET userOption2				
Call WriteString
Call crlf

mov EDX, OFFSET userOption3				
Call WriteString
Call crlf
Call ReadInt				

Opt1:
CMP EAX, 1	;compare user input to option 1
JNE Opt2	;if not equal, jump to opt2
mov n, 1000		;if option one mov 1000 to n since option one compares 2 to 1000				
Call FindPrimes		;call the function to find all primes			
Call DisplayPrimes	; print to screen					
JMP startHere		;and then jump back to the top of procedure to the main menu again							
	
Opt2:
CMP EAX, 2	;compare user input to option 2
JNE Opt3	;if not equal, jump to opt3					
Call UserInt	;get user inputted n					
Call FindPrimes	 ;call the function to find all primes		
Call DisplayPrimes	; print to screen		
JMP startHere ;and then jump back to the top of procedure to the main menu again

Opt3:
CMP EAX, 3	;compare user input to option 3					
JE finish	;exit program if input = 3						
	
finish:

exit								
ret 
displayMenu endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UserInt proc
; user input for option 2 to select maximum number in range
;receives nothing
;returns n inside eax register

.data
UserPrompt1 BYTE "Enter a number between 2 and 1000: ", 0

.code
invalidEntry:		;enter a valid number if you entered an invalid number

mov EDX, OFFSET UserPrompt1 
Call WriteString	;display userprompt			
Call ReadInt		;read n as input				
CMP EAX, 1000					

JA invalidEntry	;jump if n is greater than 1000					
CMP EAX, 2		
JB invalidEntry	;jump if n is less than 2							
mov n, EAX		;mov user input to n if valid
						
ret				
UserInt endp				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FindPrimes proc
;program to find all prime numbers within a range
;receives n from input from the user for option 2
;returns the prime number

clearECX	
Label1:		;load array with values of n 							
mov EAX, ECX 
ADD EAX, 2	;array starts with 2						
mov [primeArray + 4 * ECX], EAX		;move value to array element
INC ECX					; move to next element of array
CMP ECX, n		;compare ecx and n to see if n is greaer than ecx			
JB Label1

clearECX								
Label2:
mov EBX, ECX
INC EBX									
CMP[primeArray + 4 * ECX], 0				
JNE Label3									

ECXiter:	;need to increment ecx for division	after array is loaded						
INC ECX	
CMP ECX, n					
JB Label2									
JMP finish								

Label3:
CMP[primeArray + 4 * EBX], 0
JNE Label4									

EBXiter:		;move to next array element		
INC EBX
CMP EBX, n		;increase ebx until it equals n 
JB Label3					
JMP ECXiter		;and then jump to ECXiter	

Label4:						
clearEDX			
clearEAX		
mov EAX, [primeArray + 4 * EBX]	;mov array to eax	
DIV[primeArray + 4 * ECX]  ;divide array's elements by ecx			
CMP EDX, 0				

JE zeroComposite	    					
JMP EBXiter							
		
zeroComposite:	;replace composite numbers with 0
mov[primeArray + 4 * EBX], 0	
JMP EBXiter		;jump to next element in array			
			
finish:

ret					
FindPrimes endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DisplayPrimes proc
;display count of prime numbers, and the prime numbers to console window
;receives loaded array and n
;returns nothing

.data
Output1 BYTE "There are ", 0
Output2 BYTE " primes between 2 and n (n = ", 0
Output3 BYTE ")", 0
dashes BYTE "--------------------------------------------", 0
rowCounter BYTE 0
displayColumn BYTE 0
displayRow BYTE 2
.code
SUB n, 1	;subtract 1 from n
mov ECX, n	;move n to ecx for a counter		
mov EBX, 0				

totalLoop:	;loop to find all primes 
mov EAX, [primeArray + 4 * EBX]		
CMP EAX, 0					
JNE primeNumber	; if n is not 0, then it is a prime number		
INC EBX			;increment to next element			
JMP finishedLoop	;jump to end of the loop			

primeNumber: ;if n is prime, increment counter of how many primes
INC primeCounter				
INC EBX
					
finishedLoop: 

loop totalLoop

Call clrscr							
;display output the way it is in the .data.
mov EDX, OFFSET Output1
Call WriteString
mov AL, primeCounter
Call WriteDec

mov EDX, OFFSET Output2
Call WriteString
inc n
mov EAX, n							
Call WriteDec
dec n

mov AL, Output3
Call WriteChar
Call crlf						
		
mov EDX, OFFSET dashes
Call WriteString
Call crlf

mov EBX, 0						

;format the output where there are 5 prime numbers per row
;and each row is spaced correctly
format:
mov EAX, [primeArray + 4 * EBX]		
CMP EAX, 0							

JE compositeNumber					
mov DH, displayRow						
mov DL, displayColumn
Call GoToXY ;function to move cursor
Call WriteDec					
INC rowCounter					
CMP rowCounter, 5 ;five primes per row
JE fiveformat		;else format to make it 5 primes

ADD displayColumn, 5	;5 spaces between each prime				
INC EBX					
JMP finish				

fiveformat:
Call crlf							
sub displayColumn, 25	;5*5 =25 to move back to begining of column						
INC displayRow						
mov rowCounter, 0	
mov DL, displayColumn					
mov DH, displayRow							
Call GoToXY ;to move cursor

ADD displayColumn, 5					
INC EBX			
JMP finish					

compositeNumber:;if composite number, then skip				
INC EBX							

finish:
CMP EBX, n							
JB format

mov primeCounter, 0
mov displayRow, 2
mov displayColumn, 0
mov rowCounter, 0
Call crlf							
Call waitMSG					

ret									
DisplayPrimes endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end main  
