; TITLE: Designing low-level I/O procedures    (Project6_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 11/21/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 6                Due Date: 12/02/2018
; Description: Reads string in and writes to array if int, then will display the array, the sum, and the average
INCLUDE Irvine32.inc

;------------------------------------------------
;macro used for displaying a string, must call with address of string
displayString MACRO stringPtr
	
		push edx
		mov edx, stringPtr
		call WriteString
		pop edx

ENDM
;----------------------------------------------

;macro used for getting a string for user, must call with address of name to be filled
getString MACRO varName

		push ecx
		push edx
		mov edx, OFFSET varName
		mov ecx, (SIZEOF varName) - 1
		call ReadString
		pop edx
		pop ecx

ENDM
;----------------------------------------------

; (insert constant definitions here)
lowestNumber = 0
highestNumber = 4294967295


.data

programTitle BYTE "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
programmerName BYTE "Written by: Anthony Huynh", 0
instructions BYTE "Please provide 10 unsigned decimal integers.", 13, 10
			 BYTE "Each Number needs to be small enough to fit inside a 32 bit register.", 13, 10
			 BYTE "After you have finished inputting the raw numbers I will display a " , 13, 10
			 BYTE "list of the integers, their sum, and their average value.", 0
getNumberMessage BYTE "Please enter an unsigned number: ", 0
errorMessage BYTE "ERROR: You did not enter an unsigned number or your number was too big.", 13, 10
			 BYTE "Please try again: ", 0
threeSpaces BYTE "   ", 0
userNumbers BYTE "You entered the following numbers: ", 0
tempString BYTE 10 DUP(0)
sumMessage BYTE "The sum of these numbers is: ", 0
averageMessage BYTE "The average is: ", 0
farewell BYTE "Thanks for playing!", 0


userInputAsString BYTE 16 DUP(0)
userInputAsInt DWORD ?
array DWORD 10 DUP(?)
elementsInArray DWORD ?
sum DWORD ?
average DWORD ?

;-----------------------------------------
.code
main PROC


		; will display introduction and instructions
		displayString OFFSET programTitle
		call Crlf
		displayString OFFSET programmerName
		call Crlf
		displayString OFFSET instructions
		call Crlf

		;loop to get number from user, will loop 10 times

		mov ecx, 10
	getNumbers:
		mov userInputAsInt, 0
		displayString OFFSET getNumberMessage
		push userInputAsInt
		push OFFSET userInputAsInt
		push OFFSET errorMessage
		push OFFSET userInputAsString
		call ReadVal
		
		;puts each element in the place
		push elementsInArray
		push OFFSET array
		push userInputAsInt
		call PutInArray
		inc elementsInArray

		loop getNumbers

		;	to display the array
		displayString OFFSET userNumbers
		call Crlf
		push OFFSET threeSpaces
		push elementsInArray
		push OFFSET array
		call showArray

		;to calculate and display the sum
		displayString OFFSET sumMessage
		mov sum, 0
		push OFFSET sum
		push elementsInArray
		push OFFSET array
		call SumArray
		mov eax, sum
		push OFFSET tempString
		push eax
		call WriteVal

		;to calculate and display the average
		call Crlf
		displayString OFFSET averageMessage
		mov eax, sum
		mov ebx, 10
		cdq
		idiv ebx
		mov average, eax
		push OFFSET tempString
		push eax
		call WriteVal
		call Crlf
		
		;farewell message
		call Crlf
		displayString OFFSET farewell
		call Crlf



	

		exit	; exit to operating system
main ENDP


; (insert additional procedures here)


; ----------------------------------------------------------

;Procedure to read value from user, will invoke getString macro
;receives: address of userInputAsInt, value of userInputAsInt (0 at time), address of error message, and address of 
;			userInputAsString
;returns: value from user in userInputAsInt
;preconditions:  
;registers changed: none

ReadVal PROC
	
		pushad
		mov ebp, esp

	GetNumber:
		mov eax, 0
		getString userInputAsString
		mov ecx, eax					; moves length of userinput to ecx for loop counter
		mov esi, [ebp+36]				; places address of userInputAsString in esi


	ValidateInput:						; will jump to WrongFormat if ascii code for character is less than 48
		mov eax, 0
		lodsb							; or greater than 57, will exit if 0
		cmp al, 48					
		jl WrongFormat
		cmp al, 57
		jg WrongFormat
		jmp IsANumber

	ReturnFromConversion:
		
		loop ValidateInput
		jmp Done

	; will subtract 8 to change to decimal, then moves first digit to ecx temporarily, and moves current value 
	; of userInputAsInt(starts at 0), multiplies by 10, then adds first digit(in ecx) and restores ecx, loops
	; while the input is a number
	IsANumber:
		push ecx
		sub al, 48
		mov ecx, eax
		mov eax, [ebp+48]
		mov ebx, 10
		mul ebx
		jc WrongFormat
		add eax, ecx
		jc WrongFormat
		mov [ebp+48], eax
		pop ecx
		jmp ReturnFromConversion

	WrongFormat:						; either not all numbers, or greater than maximum				
		displayString [ebp+40]			; will request new number
		mov eax, 0
		mov [ebp+48], eax
		jmp GetNumber

	Done:
		mov ebx, [ebp+44]	;stores address of userInputAsInt in ebx
		mov [ebx], eax		; stores user input in userIntputAsInt
		popad
		ret 16


ReadVal ENDP

; -----------------------------------------------------------------

;Procedure to put value in array
;receives: numbers of elements in array, address of array, and user entered value
;returns: 
;preconditions:  
;registers changed: none
PutInArray PROC

		pushad
		mov ebp, esp

		mov ecx, [ebp+44]
		mov eax, [ebp+36]
		mov edi, [ebp+40]
		cmp ecx, 0
		jne FindCorrectIndex
		jmp RightIndex

	FindCorrectIndex:
		add edi, 4
		loop FindCorrectIndex

	RightIndex:
		mov [edi], eax

		popad
		ret 12

PutInArray ENDP

; --------------------------------------------------------------------------

;Procedure to display array
;receives: address of message for number of spaces, number of elements, and address of array
;returns: nothing
;registers changed: none

showArray PROC
		
		pushad
		mov ebp, esp

		mov ecx, [ebp+40]			;amount of elements in ecx
		mov edi, [ebp+36]			;address of array in esi


	DisplayArray:

		mov eax, [edi]
		push OFFSET tempString
		push eax
		call WriteVal
		displayString [ebp+44]


		add edi, 4
		loop DisplayArray
		jmp Done

	Done:
		call Crlf
		popad
		ret 12
showArray ENDP

; -----------------------------------------------------------------------

;Procedure to convert an integer into a string and calls the macro to display it
;receives: value to convert, and address of string
;returns: nothing
;registers changed: none


WriteVal PROC
		
		pushad
		mov ebp, esp

		mov eax, [ebp+36]				;puts what eax had before
		mov edi, [ebp+40]				;puts address of tempString
		mov ebx, 10
		mov ecx, 0

	ConversionLoop:
		cdq
		idiv ebx
		inc ecx				; to keep track of how many times we divided by 10
		push edx			;pushes remainder after dividing by 10
		cmp eax, 0
		je Done
		jmp ConversionLoop

	Done:
		pop eax
		add eax, 48
		stosb			;stores each digit as ascii code
		loop Done
		mov eax, 0		;adds 0 to end of string
		stosb

		displayString OFFSET tempString



		popad
		ret 8

WriteVal ENDP

; -----------------------------------------------------------------------

;Procedure to sum and store an array
;receives: array address, number of elements in array, address of sum
;returns: sum
;registers changed: none


sumArray PROC

		pushad
		mov ebp, esp

		mov ecx, [ebp+40]			;counter for loop
		mov edi, [ebp+36]			; address of array in edi
		mov eax, 0

	StartSum:
		add eax, [edi]
		add edi, 4

		mov ebx, [ebp+44]	;stores address of sum in ebx
		mov [ebx], eax		; stores sum
		loop StartSum

		popad
		ret 12

sumArray ENDP

END main