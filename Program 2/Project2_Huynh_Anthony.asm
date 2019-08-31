; TITLE: Fibonacci Calculation     (Project2_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 10/12/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 2                Due Date: 10/15/2018
; Description: Calculates and Displays the Fibonacci numbers up to the nth term

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

programTitle BYTE "Fibonacci Numbers",0
programmerName BYTE "Programmed by Anthony Huynh", 0
askForName BYTE "What's your name? ", 0
usersName BYTE 21 DUP(0)
nameLength DWORD ?
introduction BYTE "Hello, ", 0
fibonacciRequest BYTE "Enter the number of Fibonacci terms to be displayed.", 0
displayRange BYTE "Give the number as an integer in the range [1 .. 46].", 0
getFibonacciTerms BYTE "How many Fibonacci terms do you want? ", 0
amountFibonacci DWORD ?
outOfRange BYTE "Out of range. Enter a number in [1 .. 46]", 0
numbInRange BYTE "Number is in range", 0
fiveSpaces BYTE "     ", 0
tempNum DWORD ?
numbPerLine DWORD 5
numbCount DWORD ?
certified BYTE "Results certified by Anthony Huynh.", 0
goodbye BYTE "Goodbye, ", 0
period BYTE ".", 0




.code
main PROC

; Displaying program title
	mov edx, OFFSET programTitle
	call WriteString
	call Crlf

; Displaying programmer's name
	mov edx, OFFSET programmerName
	call WriteString
	call Crlf

; Getting user's name and putting amount of letters in nameLength
	call Crlf
	mov edx, OFFSET askForName
	call WriteString
	
	mov edx, OFFSET usersName
	mov ecx, SIZEOF usersName
	call ReadString
	mov nameLength, eax
	
; Introduction that says hello and user's name
	call Crlf
	mov edx, OFFSET introduction
	call WriteString
	mov edx, OFFSET usersName
	call WriteString
	call Crlf

; Instructions
	mov edx, OFFSET fibonacciRequest
	call WriteString
	call Crlf

	mov edx, OFFSET displayRange
	call WriteString
	call Crlf

; Getting number of Fibonacci terms from user, starts loop if user enters number out of range
BeginRangeLoop:
	mov edx, OFFSET getFibonacciTerms
	call WriteString
	call ReadInt
	mov amountFibonacci, eax

; To make sure number is in range
	mov eax, amountFibonacci
	cmp eax, 1
	jl NotInRange	; jumps to NotInRange if eax is less than 1
	cmp eax, 46
	jg NotInRange	; jumps to NotInRange if eax is greater than 46
	jmp InRange		; jumps to InRange if number is between 1 and 46

; NotInRange loop for when user does not enter a number within range
NotinRange:
	mov edx, OFFSET outOfRange
	call WriteString
	call Crlf
	jmp BeginRangeLoop
	
; Loop that will be jumped to if number is within range
InRange:
	call Crlf
	mov ecx, amountFibonacci	;set loop counter
	mov eax, 1
	mov ebx, 0
	mov tempNum, 0
	mov numbCount, 0
		
; To start calculating and displaying Fibonacci numbers
FibonacciLoop:

	call WriteDec

	mov edx, OFFSET fiveSpaces
	call WriteString

	; tempNum will hold what eax is before ebx is added, then ebx is added to eax and stored in eax,
	; then ebx changes to what eax was before the addition, after all that is done, it loops again 

	mov tempNum, eax
	add eax, ebx
	mov ebx, tempNum

	; moves numbCount to edx after displaying each number, then increases edx and compares to numbPerLine (5)
	; if edx = 5, then jumps to FifthNumber, going to the next line and resetting the number count
	; if edx =/= 5, then loop will just continue without going to a new line

	mov edx, numbCount
	inc edx
	cmp edx, numbPerLine
	je MaxNumberPerLine
	mov numbCount, edx
	jmp NotMaxPerLine

MaxNumberPerLine:
	call Crlf
	mov numbCount, 0

NotMaxPerLine:
	loop FibonacciLoop			; repeat the loop

; Farewell
	call Crlf
	mov edx, OFFSET certified
	call WriteString
	call Crlf
	
	mov edx, OFFSET goodbye
	call WriteString

	mov edx, OFFSET usersName
	call WriteString
	mov edx, OFFSET period
	call WriteString
	call Crlf
		


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
