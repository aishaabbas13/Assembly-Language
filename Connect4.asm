; Test3
;Connect 3 game on a 4x4 board
;can play:
;playerVplayer
;playerVcpu
;cpuVcpu

;Aisha Qureshi
;12/11/2017

INCLUDE Irvine32.inc

clearEAX TEXTEQU <mov eax, 0>
clearEBX TEXTEQU <mov ebx, 0>
clearECX TEXTEQU <mov ecx, 0>
clearEDX TEXTEQU <mov edx, 0>
clearESI TEXTEQU <mov esi, 0>
clearEDI TEXTEQU <mov edi, 0>

displayMenu proto
printBLACKK proto
printBLUEE  proto
printYELLOWW proto
printFUNC proto
clearFunc proto
cpuSWITCH proto
cpuVcpu proto
playerSWITCH proto
playerVplayer proto
playerVcpu proto
checkROWS proto
checkCOLS proto
oops proto

.data
 UserOption BYTE 0h
 BoardArray BYTE 0,0,0,0, 
				 0,0,0,0,
				 0,0,0,0,
				 0,0,0,0
				 
WinPrompt byte "Won: ", 0
LosePrompt byte "Losses: ", 0
TiePrompt byte "Ties: ", 0				 
				 
Won byte 0
Losses byte 0
Ties byte 0
  
.code
main PROC
 
;//clear registers

clearEAX
clearEBX
clearECX
clearEDX
clearESI
clearEDi

startHere:
;show scores of wins, losses, and ties of player 1
invoke clrscr
mov edx, offset WinPrompt
invoke writeString
mov al, Won
invoke writeDec
invoke crlf

mov edx, offset LosePrompt
invoke writeString
mov al, Losses
invoke writeDec
invoke crlf

mov edx, offset TiePrompt
invoke writeString
mov al, Ties
invoke writeDec
invoke crlf
invoke waitmsg


invoke DisplayMenu
invoke ReadHex
mov UserOption, al

mov edx, offset BoardARRAY

;options relating to display menu for what user can do
;playerVplayer
opt1:
cmp UserOption, 1
jne Opt2
invoke clrscr
invoke playerVplayer
cmp eax, 1
je yayWon
cmp eax, 0 
je awLosses
cmp eax, 2
je okTies
invoke clearFunc
invoke waitmsg
jmp startHere
;playerVcpu
opt2:
cmp UserOption, 2
jne Opt3
invoke clrscr
invoke playerVcpu
cmp eax, 1
je yayWon
cmp eax, 0 
je awLosses
cmp eax, 2
je okTies
invoke clearFunc
invoke waitmsg
jmp startHere
;cpuVcpu
opt3:
cmp UserOption, 3
jne Opt4
invoke clrscr
invoke cpuVcpu
cmp eax, 1
je yayWon
cmp eax, 0 
je awLosses
cmp eax, 2
je okTies
invoke clearFunc
invoke waitmsg
jmp startHere
;exit
opt4:
cmp UserOption, 4
je quitit
invoke oops
jmp startHere

;increment score of wins
yayWon:
inc Won
invoke clearFunc
jmp startHere

;increment score of losses
awLosses:
inc Losses
invoke clearFunc
jmp startHere

;increment score of ties
okTies:
inc Ties
invoke clearFunc
jmp startHere

quitit:

exit
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayMenu PROC uses EDX
;Description:  Displays menu
;Receives: Nothing
;Returns: Nothing
;
 
.data
Menuprompt1 BYTE 'MAIN MENU', 0Ah, 0Dh,
'=========', 0Ah, 0Dh,
'Get 3 in a row of your', 0Ah, 0Dh,
' own color to win', 0Ah, 0Dh,
'The 3 in a row can be in rows, columns, or diagonally', 0Ah, 0Dh,
'1. Player VS Player', 0Ah, 0Dh,
'2. Player VS CPU', 0Ah, 0Dh,
'3. CPU VS CPU', 0Ah, 0Dh,
'4. Quit', 0Ah, 0Dh, 0h
.code
invoke clrscr
mov edx, Offset Menuprompt1
invoke WriteString
ret
displayMenu ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printFUNC PROC
;prints board and colors
;returns nothing
.data
dashes byte "---------------------",0

.code
mov ecx, 4
push edx
mov edx, offset dashes
invoke writeString
pop edx
invoke crlf

loopROW:	;diplay rows of board
push ecx
mov ecx, 4
mov al, 7ch
invoke writeChar
push EDI
loopCOL: ;display columns of board
movzx ebx, byte PTR [edx+edi] ;edx= addy of array, edi = col number
cmp ebx, 0
je printBLACK
cmp ebx, 'a'
je printBLUE
cmp ebx, 'b'
je printYELLOW

;print blach for empty board
printBLACK:
invoke printBLACKK     
jmp finishCOL

;print blue for player1
printBLUE:
invoke printBLUEE          
jmp finishCOL
;print blue for player2
printYELLOW:
invoke printYELLOWW


finishCOL:
mov al, 7ch
invoke writeChar
inc edi
loop loopCOL

invoke crlf
push edx
mov edx, offset dashes
invoke writeString
pop edx

invoke crlf
pop edi
pop ecx
add edx, 4
loop loopROW
ret
printFUNC ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printBLACKK proc
;print black spaces in the board as empty space

mov al, 20h         
invoke writechar     
invoke writechar    
invoke writechar     
invoke writechar
ret
printBLACKK endp
 
printBLUEE PROC
;print plue space to fill up where player 1 chose
mov al, white + (Blue* 16)     
invoke SetTextColor        
mov al, 20h        
invoke writechar          
invoke writechar         
invoke writechar        
invoke writechar        
mov al, white + (Black* 16)      
invoke SetTextColor
ret
printBLUEE endp 

printYELLOWW PROC
;print yellow space to fill up where player 1 chose
mov al, white + (YELLOW* 16)      
invoke SetTextColor       
mov al, 20h       
invoke writechar     
invoke writechar      
invoke writechar       
invoke writechar   
mov al, white + (Black* 16)  
invoke SetTextColor
ret
printYELLOWW endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cpuSWITCH proc
;func that generates rand remainder between 0 and 3
;player letter in eax
;recieves nothing
;returns nothing
.code
top:
push eax
push edx
clearEDX
invoke randomize
invoke random32
mov esi, 4			;algorithm to create a remainder from 0-3 to be inserted in board
DIV esi
mov edi, edx
pop edx
pop eax


push edx
add edx,12	;start from last row
push ecx
mov ecx, 4 
push EDI
;sub edi, 1

loop1:
movzx ebx, byte PTR [edx+edi] ;edx= addy of array, edi = col number
cmp ebx, 0
je emptySpace	;if space is empty, jump
sub edx, 4
loop loop1
pop EDI
pop ecx
pop edx
jmp top

emptySpace:				; fill empty space
mov byte ptr[edx + edi], al ;edx= addy of array, edi = col number
pop EDI
pop ecx
pop edx
ret
cpuSWITCH endp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cpuVcpu proc
;program where computers play against each other
;retruns colors to board
;
.data
UserPrompt1 byte "CPU1 Wins!", 0Ah, 0Dh, 0h
UserPrompt2 byte "CPU1 Loses!", 0Ah, 0Dh, 0h
UserPrompt3 byte "Tie!", 0Ah, 0Dh, 0h
.code
mov ecx, 16

loopCPU1:	;loops cpu1 to display to board
mov eax, 'a'
push edx
push edi
invoke cpuSWITCH ;call function 
pop edi
pop edx
push ecx
invoke checkRows ;check if there are 3 of the same color in a row
cmp eax, 1
mov eax, 1
je Winner ;then p1 wins
pop ecx
push ecx
invoke checkCOLS ;;check if there are 3 of the same color in a column
cmp eax, 1
mov eax, 1
je Winner ;then p1 wins
pop ecx
push edx
push ecx
mov edi, 0
invoke printFUNC ;prnt to screen
pop ecx
pop edx
loop loopCPU2

loopCPU2:
mov eax, 'b'
push edx
push edi
invoke cpuSWITCH
pop edi
pop edx
invoke checkRows ;;check if there are 3 of the same color in a row
cmp eax, 1
mov eax, 0
je Loser ;then p1 loses
invoke checkCOLS ;check if there are 3 of the same color in a column
cmp eax, 1
mov eax, 0
je Loser ;then p1 loses
push edx
push ecx
invoke printFUNC
pop ecx
pop edx
loop loopCPU1
mov eax, 2
jmp Tie

Winner: ;print win statement
push edx
mov edx, offset UserPrompt1
invoke writeString
pop edx
jmp done123

Loser: ;print lose statement
push edx
mov edx, offset UserPrompt2
invoke writeString
pop edx
jmp done123

Tie: ;print tie statement
push edx
mov edx, offset UserPrompt3
invoke writeString
pop edx
jmp done123

done123:

ret
cpuVcpu endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playerSWITCH PROC
;switch between the playes 1 and 2
.data 
USERprompt byte "Enter a column: ", 0
USERinput byte ?

.code
top1:

push eax
push edx
clearEDX
mov edx, offset USERprompt
invoke writeString
invoke readHex
mov edi, eax
pop edx
pop eax

cmp edi, 1
je GOOD
cmp edi, 2
je GOOD
cmp edi, 3
je GOOD
cmp edi, 4
je GOOD

jmp top1


GOOD:
push edx
add edx,12
push ecx
mov ecx, 4 
push EDI
sub edi, 1

loop11:
movzx ebx, byte PTR [edx+edi] ;edx= addy of array, edi = col number
cmp ebx, 0
je emptySpace1	
sub edx, 4
loop loop11
pop EDI
pop ecx
pop edx
jmp top1

emptySpace1:
mov byte ptr[edx + edi], al
pop edi 
pop ecx
pop edx
ret
playerSWITCH endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playerVplayer proc
;2 people play against each other
.data
UserPrompt11 byte "Player1 Wins!", 0Ah, 0Dh, 0h
UserPrompt22 byte "Player1 Loses!", 0Ah, 0Dh, 0h
UserPrompt33 byte "Tie!", 0Ah, 0Dh, 0h
.code
mov ecx, 16

loopPLAYER1:
mov eax, 'a'
push edx
push edi
invoke playerSWITCH
pop edi
pop edx
push edx
push ecx
invoke printFUNC
pop ecx
pop edx
invoke checkRows
cmp eax, 1
mov eax, 1
je Winnerr
invoke checkCOLS
cmp eax, 1
mov eax, 1
je Winnerr
loop loopPLAYER2

loopPLAYER2:
mov eax, 'b'
push edx
push edi
invoke playerSWITCH
pop edi
pop edx
push edx
push ecx
invoke printFUNC
pop ecx
pop edx
invoke checkROWS
cmp eax, 1
mov eax, 0
je Loserr
invoke checkCOLS
cmp eax, 1
mov eax, 0
je Loserr

loop loopPLAYER1

mov eax, 2
jmp Tiee

Winnerr:
push edx
mov edx, offset UserPrompt11
invoke writeString
pop edx
jmp done1234

Loserr:
push edx
mov edx, offset UserPrompt22
invoke writeString
pop edx
jmp done1234

Tiee:
push edx
mov edx, offset UserPrompt33
invoke writeString
pop edx
jmp done1234

done1234:


ret
playerVplayer endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playerVcpu PROC
;person plays against cpu 
.data
UserPrompt111 byte "Player1 Wins!", 0Ah, 0Dh, 0h
UserPrompt222 byte "Player1 Loses!", 0Ah, 0Dh, 0h
UserPrompt333 byte "Tie!", 0Ah, 0Dh, 0h
.code
mov ecx, 16

loopPLAYER1:
mov eax, 'a'
push edx
push edi
invoke playerSWITCH
pop edi
pop edx
push edx
push ecx
invoke printFUNC
pop ecx
pop edx
invoke checkRows
cmp eax, 1
mov eax, 1
je Winnerrr
invoke checkCOLS
cmp eax, 1
mov eax, 1
je Winnerrr

loop loopPLAYER2

loopPLAYER2:
mov eax, 'b'
push edx
push edi
invoke cpuSWITCH
pop edi
pop edx
push edx
push ecx
invoke printFUNC
pop ecx
pop edx
invoke checkRows
cmp eax, 1
je Loserrr
mov eax, 0
invoke checkCOLS
cmp eax, 1
mov eax,0
je Loserrr

loop loopPLAYER1

mov eax, 2
jmp Tieee

Winnerrr:
push edx
mov edx, offset UserPrompt111
invoke writeString
pop edx
jmp done12345

Loserrr:
push edx
mov edx, offset UserPrompt222
invoke writeString
pop edx
jmp done12345

Tieee:
push edx
mov edx, offset UserPrompt333
invoke writeString
pop edx
jmp done12345

done12345:

ret
playerVcpu ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
oops Proc USES EDX
;Description: Prints error message
;Receives nothing
;returns nothing
.data
Caption BYTE "*** Error ***",0
OopsMsg BYTE "You have chosen an invalid option!", 0ah, 0dh, 0

.code
mov edx, Offset Caption
mov edx, offset OopsMsg
invoke msgBox
ret
Oops ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clearFunc Proc
;clear the board
.code
mov ecx, 16
mov eax, 0
push edi
loopClr:
mov byte ptr [edx + edi], al
inc edi
loop loopClr
pop edi
ret
clearFunc ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkROWS Proc
;check if there are 3 of the same color in a row
.data
PlayerAns byte 0

.code
pushad
mov ecx, 4
mov edi, 3
add edx, 12
rowCheck:
mov al, byte ptr [edx + edi]
cmp al, 0
jne nextSpot
sub edx, 4 
loop rowCheck
jmp notWin

nextSpot:
push edi
mov PlayerAns, al
dec edi
mov al, byte ptr [edx + edi]
cmp PlayerAns, al
jne Loss

dec edi
mov al, byte ptr [edx + edi]
cmp PlayerAns, al
jne Loss
pop edi
jmp Win

Loss: 
sub edx, 4
pop edi
loop rowCheck

jmp notWin

Win:
popad
mov eax, 1
jmp finished

notWin:
popad
mov eax, 0

finished:

ret
checkROWS ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkCOLS Proc
;chech if there are 3 of the same color in a column
.data
PlayerAns2 byte 0
.code
pushad
mov ecx, 4
mov edi,3
add edx, 12
colCheck:
mov al, byte ptr [edx + edi]
cmp al, 0
jne nextSpot2
dec edi 
loop colCheck
jmp notWin2

nextSpot2:
mov PlayerAns2, al
push edx
sub edx, 4
mov al, byte ptr [edx + edi]
cmp PlayerAns2, al
jne Loss2

sub edx, 4
mov al, byte ptr [edx + edi]
cmp PlayerAns2, al
jne Loss2
pop edx
jmp Win2

Loss2:
dec edi
pop edx
loop colCheck
jmp notWin2

Win2:
popad
mov eax, 1
jmp finished2

notWin2:
popad
mov eax, 0

finished2:

ret
checkCOLS ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;didnt have time to make my diagonal function
;but would check between the rows and columns to grab the bottom left 
;of the selected row and column
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END main


