; TITLE: Composite Numbers     (Project4_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 10/25/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 4                Due Date: 11/04/2018
; Description: Determines and displays composite numbers, amount displayed will be specified by the users
INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN_INPUT EQU 1
MAX_INPUT EQU 400

.data

programTitleAndProgrammerName BYTE "Composite Numbers	by Anthony Huynh",0
instructions BYTE "Enter the number of composite numbers you would like to see. ", 0
instructionsPart2 BYTE "I''ll accept orders for up to 400 composites.", 0
gettingUserInput BYTE "Enter the number of composites to display [1 .. 400]: ", 0
outOfRangeMessage BYTE "Out of range. Try again. ", 0
numberComposite DWORD ?
farewellMessage BYTE "Results certified by Anthony Huynh.  Goodbye. ", 0
numberToBeChecked DWORD 2
divisor DWORD 2
threeSpaces BYTE "   ",0
numberPerLine DWORD 0

testMessage BYTE "in not a composite", 0





.code
main PROC

	call introduction
	call getUserData
	call showComposites
	call farewell
	

	exit	; exit to operating system
main ENDP


; (insert additional procedures here)


;Procedure to display the introduction
;receives: global variables holding program/programmer name and instructions
;returns: none
;preconditions:  none
;registers changed: none

introduction PROC
		mov edx, OFFSET programTitleAndProgrammerName
		call WriteString
		call Crlf

		mov edx, OFFSET instructions
		call WriteString
		call Crlf

		mov edx, OFFSET instructionsPart2
		call WriteString
		call Crlf

	ret
introduction ENDP


;Procedure to get user data and verify user input
;receives: global variables
;returns: amount of numbers to be displayed in amountComposite
;preconditions:  none
;registers changed: none

getUserData PROC

	; loop to get user data
	UserInputLoop:
		mov edx, OFFSET gettingUserInput
		call WriteString
		call ReadInt
		cmp eax, MIN_INPUT
		jl NotInRange
		cmp eax, MAX_INPUT
		jg NotInRange
		jmp InRange

	; if not in range, will call loop again
	NotInRange:
		mov edx, OFFSET outOfRangeMessage
		call WriteString
		call Crlf
		jmp UserInputLoop

	; if in range, will move eax to numberComposite variable and return to calling function
	InRange:
		mov numberComposite, eax
		ret

getUserData ENDP


;Procedure for the farewell
farewell PROC
		mov edx, OFFSET farewellMessage
		call WriteString
		call Crlf
		ret
farewell ENDP

;Procedure to check if a number is composite and display if it is, number will start at 2
;receives: global variables holding program/programmer name and instructions
;returns: none
;preconditions:  none
;registers changed: none

showComposites PROC
		mov ecx, numberComposite
	BeginCheck:
		mov eax, numberToBeChecked
		cmp eax, divisor
		je NotComposite					;if numberToBeChecked == divisor, then jumps to not composite


		cdq
		idiv divisor

		cmp edx, 0
		je IsComposite
		jne CheckNextDivisor

	NotComposite:						;increases numberToBeChecked and resets starting divisor to
		inc numberToBeChecked
		mov divisor, 2
		jmp BeginCheck

	CheckNextDivisor:					;will increase divisor to be checked
		inc divisor
		jmp BeginCheck

	IsComposite:										; will display if composite, decreases numberComposite and compares
		mov eax, numberToBeChecked						; to 0, will jump to done if == 0
		call WriteDec
		inc numberToBeChecked
		mov divisor, 2
		inc numberPerLine
		mov eax, numberPerLine
		cmp eax, 10
		je NewLine
		mov edx, OFFSET threeSpaces
		call WriteString
		loop BeginCheck
		jmp Done
		

	NewLine:
		mov numberPerLine, 0
		call Crlf
		loop BeginCheck

	Done:
		call Crlf
		ret
showComposites ENDP

END main
