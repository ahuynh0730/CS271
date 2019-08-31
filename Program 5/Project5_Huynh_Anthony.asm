; TITLE: Sorting Random Integers    (Project5_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 10/25/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 4                Due Date: 11/04/2018
; Description: Determines and displays composite numbers, amount displayed will be specified by the users
INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN_INPUT EQU 10
MAX_INPUT EQU 200
LO_RANDOM EQU 100
HIGH_RANDOM EQU 999

.data

programTitleAndProgrammerName BYTE "Sorting Random Integers			Programmed by Anthony Huynh",0
instructions BYTE "This program generates random numbers in the range [100 .. 999]," ,0
instructionsPart2 BYTE "displays the original list, sorts the list, and calculates the median value.", 0
instructionsPart3 BYTE "Finally, it displays the list sorted in descending order. ", 0
gettingUserInput BYTE "How many numbers should be generated? [10 .. 200]:  ", 0
outOfRangeMessage BYTE "Invalid input ", 0
numberOfElements DWORD ?
array DWORD MAX_INPUT DUP(?)
unsortedMessage BYTE "The unsorted random numbers: ", 0
medianMessage BYTE "The median is ", 0
sortedMessage BYTE "The sorted list: "
threeSpaces BYTE "   ", 0







.code
main PROC

	call Randomize

	push OFFSET instructionsPart3				; displaying intro and instructions
	push OFFSET instructionsPart2
	push OFFSET instructions
	push OFFSET programTitleAndProgrammerName
	call introduction

	call Crlf
	push OFFSET outOfRangeMessage
	push OFFSET gettingUserInput
	push OFFSET numberOfElements		;gets number of elements from user
	call getUserData

	push numberOfElements				;fills array randomly
	push OFFSET array
	call fillArray
	
	call Crlf
	push OFFSET threeSpaces
	push OFFSET unsortedMessage		;displays unsorted array
	push numberOfElements
	push OFFSET array
	call showArray

	push numberOfElements			;sorts array
	push OFFSET array
	call sortArray

	call Crlf						;calculates and displays median
	push OFFSET medianMessage
	push numberOfElements
	push OFFSET array
	call findMedian
	call WriteDec
	call Crlf

	call Crlf
	push OFFSET threeSpaces
	push OFFSET sortedMessage		;displays sorted array					
	push numberOfElements
	push OFFSET array
	call showArray

	

	exit	; exit to operating system
main ENDP


; (insert additional procedures here)


;Procedure to display the introduction
;receives: address of program/programmer name and instructions
;returns: none
;preconditions:  title, and instructions address on stack
;registers changed: edx

introduction PROC

		push ebp
		mov ebp, esp

		mov edx, [ebp+8]
		call WriteString
		call Crlf

		mov edx, [ebp+12]
		call WriteString
		call Crlf

		mov edx, [ebp+16]
		call WriteString
		call Crlf

		mov edx, [ebp+20]
		call WriteString
		call Crlf

		pop ebp
		ret 16
introduction ENDP


;Procedure to get user data and verify user input
;receives: address of numberOfElements
;returns: amount of numbers to be generated
;preconditions:  address of numberOfElements in stack, then address of gettingUserInput string, then address of outOfRange string
;registers changed: eax, edx

getUserData PROC
		
	push ebp
	mov ebp, esp

	;will ask user for number, if less than min or greater than max, 
	; then will keep repeating until in range
	Start:
		mov edx, [ebp+12]
		call WriteString
		call ReadDec
		cmp eax, MIN_INPUT
		jl OutOfRange
		cmp eax, MAX_INPUT
		jg OutOfRange
		jmp InRange

	OutOfRange:
		mov edx, [ebp+16]
		call WriteString
		call Crlf
		jmp Start

	InRange:
		mov ebx, [ebp+8]	;stores address of numberOfElements in ebx
		mov [ebx], eax		; stores user input in numberOfElmenets

		pop ebp
		ret 12
getUserData ENDP

;Procedure to fill array
;receives: number of elements to fill array, array's address
;returns: array with elements in it
;preconditions:  array's address above number of elements in stack
;registers changed: eax, ecx, edi

fillArray PROC
	
		push ebp
		mov ebp, esp

		mov ecx, [ebp+12]			;count in ecx
		mov edi, [ebp+8]			;address of array in edi

	;following code obtained from demo5.asm and slides on canvas
	GenerateNumbers:
		mov eax, HIGH_RANDOM		;999
		sub eax, LO_RANDOM			;999-100=899
		inc eax						;900
		call RandomRange
		add eax, LO_RANDOM			;adding lowest number to eax to set range properly
		mov [edi], eax				;moving eax into next array element
		add edi, 4
		loop GenerateNumbers

		pop ebp
		ret 8

fillArray ENDP

;Procedure to display array
;receives: number of elements in array, array's address
;returns: nothing
;preconditions:  array's address above number of elements in stack
;registers changed: eax, edi, ecx, edx

showArray PROC
		
		push ebp
		mov ebp, esp

		mov ecx, [ebp+12]			;amount of elements in ecx
		mov edi, [ebp+8]			;address of array in esi

		mov edx, [ebp+16]
		call WriteString
		call Crlf
		
		mov edx, 10
		

	DisplayArray:
		push edx		;pushes amount left to print on line

		mov eax, [edi]
		call WriteDec
		mov edx, [ebp+20]
		call WriteString

		pop edx			;after displaying, will pop amount left to print on line and decremenent by 1
		dec edx			; if == 0, will jump to NewLine 
		cmp edx, 0
		je NewLine


		add edi, 4
		loop DisplayArray
		jmp Done

	NewLine:
		mov edx, 10
		call Crlf
		add edi, 4
		loop DisplayArray

	Done:
		call Crlf
		pop ebp
		ret 16
showArray ENDP


;code was borrowed from 9.5 of Assembly Language for x86 Processors book

;Procedure to sort array using bubble sort 
;receives: number of elements in array, array's address
;returns: nothing
;preconditions:  array's address above number of elements in stack
;registers changed: eax, edi, ecx

sortArray PROC
		push ebp
		mov ebp, esp

		mov ecx, [ebp+12]		;amount of elements in ecx
		mov edi, [ebp+8]		;address of array in edi

	L1:
		push ecx				;save outer loop count
		mov edi, [ebp+8]

	L2:
		mov eax, [edi]			;will compare two values, and swap them if the first is less than the second
		cmp eax, [edi+4]		;then will compare next two values
		jg L3
		xchg eax, [edi+4]
		mov [edi], eax

	L3:
		add edi, 4				; move edi to next element of array
		loop L2

		pop ecx					
		loop L1

		pop ebp
		ret 8
sortArray ENDP



;Procedure to to find median of sorted array
;receives: number of elements in array, array's address
;returns: median in eax
;preconditions:  array's address above number of elements in stack
;registers changed: eax, edi, edx, ebx

findMedian PROC
		push ebp
		mov ebp, esp

		mov edx, [ebp+16]
		call WriteString

		mov eax, [ebp+12]		;number of elements in eax
		mov edi, [ebp+8]
		cdq						; will determine if there are an odd or even amount and jump to appropiate area
		mov ebx, 2
		idiv ebx
		cmp edx, 1
		je OddAmount
		jmp EvenAmount


	OddAmount:
		mov ebx, 4			
		imul ebx				; eax will be 4 * quotient of (amount/2)
		add edi, eax			; adds eax to edi
		mov eax, [edi]			; moves the median value to eax
		jmp Done

	EvenAmount:
		mov ebx, 4
		imul ebx
		add edi, eax
		mov eax, [edi]
		add eax, [edi-4]
		mov ebx, 2
		idiv ebx
		cmp edx, 0
		jz Done				; if there is no remainder after dividing by two, will be done
		jmp AddOne			; otherwise will increment eax by 1

	AddOne:
		inc eax


	Done:
		pop ebp
		ret 12

findMedian ENDP



END main
