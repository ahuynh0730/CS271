; TITLE: Integer Accumulator     (Project3_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 10/22/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 2                Due Date: 10/28/2018
; Description: Counts and Accumulates user input until a non-negative number is inputted

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN EQU -100
MAX EQU -1

.data

programTitleAndProgrammerName BYTE "Welcome to the Integer Accumulator by Anthony Huynh",0
askForName BYTE "What is your name? ", 0
usersName BYTE 21 DUP(0)
nameLength DWORD ?
introduction BYTE "Hello, ", 0
instructions BYTE "Please enter numbers in [" , 0
comma BYTE ", ", 0
rightBracket BYTE "]." ,0
instructionsPart2 BYTE "Enter a non-negative number when you are finished to see results.", 0
enterNumber byte ". Enter number: ", 0
sumOfNumbers SDWORD ?
farewellPart1 BYTE "You entered ", 0
amountNumbers DWORD ?
farewellPart2 BYTE " valid numbers.", 0
notInRangeMessage BYTE "You entered a number below -100. Please try again. ", 0
sumMessage BYTE "The sum of your valid numbers is ", 0
roundedMessage BYTE "The rounded average is ", 0
roundedAverage DWORD ?
goodbye BYTE "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
halfAmountNumbers DWORD ?
remainder DWORD ?
extraCredit BYTE "**EC: Program will number the lines during user input. Starts with 1, and only increments if valid input is given.", 0

testMessage BYTE "Test message", 0





.code
main PROC

; Displaying program title and extra credit
	mov edx, OFFSET programTitleAndProgrammerName
	call WriteString
	call Crlf

	mov edx, OFFSET extraCredit
	call WriteString
	call Crlf


; Getting user's name and putting amount of letters in nameLength
	mov edx, OFFSET askForName
	call WriteString
	
	mov edx, OFFSET usersName
	mov ecx, SIZEOF usersName
	call ReadString
	mov nameLength, eax
	
; Introduction that says hello and user's name
	mov edx, OFFSET introduction
	call WriteString
	mov edx, OFFSET usersName
	call WriteString
	call Crlf

; Instructions
	mov edx, OFFSET instructions
	call WriteString
	mov eax, MIN
	call WriteInt
	mov edx, OFFSET comma
	call WriteString
	mov eax, MAX
	call WriteInt
	mov edx, OFFSET rightBracket
	call WriteString
	call Crlf
	mov edx, OFFSET instructionsPart2
	call WriteString
	call Crlf

	; start getting numbers from user

	mov ebx, 0
	mov sumOfNumbers, 0

UserInput:

	mov eax, amountNumbers
	inc eax
	call WriteDec
	
	mov edx, OFFSET enterNumber
	call WriteString
	call ReadInt
	cmp eax, MIN
	jl NotInRange			;jumps if number is less than -100
	cmp eax, MAX
	jg NonNegative			;jumps if number is greater than -1
	inc amountNumbers
	mov ebx, sumOfNumbers
	add ebx, eax
	mov sumOfNumbers, ebx
	jmp UserInput
	
NotInRange:
	mov edx, OFFSET notInRangeMessage
	call WriteString
	call Crlf
	jmp UserInput
	

NonNegative:
	mov edx, OFFSET farewellPart1
	call WriteString

	; display how many valid numbers were entered
	mov eax, amountNumbers
	call WriteDec
	mov edx, OFFSET farewellPart2
	call WriteString
	call Crlf

	; displays sum of valid numbers
	mov edx, OFFSET sumMessage
	call WriteString
	mov eax, sumOfNumbers
	call WriteInt
	call Crlf

	; calculates and displays average of numbers

	mov edx, OFFSET roundedMessage
	call WriteString
	mov roundedAverage, 0
	mov ebx, amountNumbers
	cdq
	idiv ebx
	mov roundedAverage, eax
	mov remainder, edx
	neg remainder					; to make remainder positive


	
	; to determine if more than half was left
	mov eax, amountNumbers
	mov ebx, 2
	cdq
	idiv ebx
	mov halfAmountNumbers, eax

	mov eax, edx
	cmp eax, 0
	jg OddNumber
	jmp EvenNumber

OddNumber:
	inc halfAmountNumbers

EvenNumber:
	mov eax, remainder
	cmp eax, halfAmountNumbers
	jge HalfOrAbove					;jumps if remainder is greater than or equal to half of numbers inputted
	jmp NotHalfOrAbove

HalfOrAbove:
	dec roundedAverage

NotHalfOrAbove:
	mov eax, roundedAverage
	call WriteInt
	call Crlf

	; saying goodbye
	mov edx, OFFSET goodbye
	call WriteString
	mov edx, OFFSET usersName
	call WriteString
	call Crlf





	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
