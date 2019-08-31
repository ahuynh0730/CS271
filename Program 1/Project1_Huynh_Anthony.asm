; TITLE: Elementary Arithmetic     (Project1_Huynh_Anthony.asm)

; Author: Anthony Huynh
; Last Modified: 09/25/2018
; OSU email address: huynhant@oregonstate.edu
; Course number/section: CS 271-400
; Project Number: 1                Due Date: 09/30/2018
; Description: Calculates the sum, difference, product, (integer) quotient, and remainder of 
;		numbers given by user

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

title_Name BYTE "	Elementary Arithmetic		by Anthony Huynh",0
introduction BYTE "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder", 0
first_Number BYTE "First number: ", 0
user_First_Number DWORD ?
second_Number BYTE "Second number: ", 0
user_Second_Number DWORD ?
sum DWORD ?
difference DWORD ? 
product DWORD ?
quotient DWORD ?
remainder DWORD ?
plus_Sign BYTE " + ", 0
equal_Sign BYTE " = ", 0
minus_Sign BYTE " - ", 0
times_Sign BYTE " x ", 0
division_Sign BYTE " / ", 0
remainder_String BYTE " remainder ", 0
goodbye BYTE "Impressed? Bye!", 0
continue BYTE "Would you like to continue? ", 0
extra1 BYTE "**EC: Program repeats until the user chooses to quit. ", 0
if_1 BYTE "If yes, press 1. If no, push any other key. ", 0
repeat_Choice DWORD ?
extra2 BYTE "**EC: Program verifies second number less than the first.", 0
second_Bigger BYTE "The second number must be less than the first!", 0

.code
main PROC

; My name and Program Title 
	mov edx,OFFSET title_Name
	call WriteString
	call CrLf

; Extra Credit
	mov edx, OFFSET extra1
	call WriteString
	call CrLf

	mov edx, OFFSET extra2
	call WriteString
	call CrLf

; Introduction
	call CrLF
	mov edx, OFFSET introduction
	call WriteString
	call Crlf

; Asking for first number
	call CrLf
	mov edx, OFFSET first_Number
	call WriteString

	mov edx, OFFSET user_First_Number
	call ReadInt
	mov user_First_Number, eax

; Asking for second number
	mov edx, OFFSET second_Number
	call WriteString

	mov edx, OFFSET user_Second_Number
	call ReadInt
	mov user_Second_Number, eax
	call CrLf

; To verify second number is less then the first
	mov eax, user_First_Number
	mov ebx, user_Second_Number
	.IF eax > ebx


	; Calculating required values
		; Calculate Sum
			mov eax, user_First_Number
			add eax, user_Second_Number
			mov sum, eax

		; Calculate Difference
			mov eax, user_First_Number
			sub eax, user_Second_Number
			mov difference, eax

		; Calculate Product
			mov eax, user_First_Number
			mov ebx, user_Second_Number
			mul ebx
			mov product, eax

		; Calculate Integer Quotient and Remainder
			mov eax, user_First_Number
			mov ebx, user_Second_Number
			div ebx
			mov quotient, eax
			mov remainder, edx

		
	; Displaying the results
		; Displaying sum
			mov eax, user_First_Number
			call WriteDec

			mov edx, OFFSET plus_Sign
			call WriteString

			mov eax, user_Second_Number
			call WriteDec 

			mov edx, OFFSET equal_Sign
			call WriteString

			mov eax, sum
			call WriteDec
			call CrLf

		; Displaying Difference
			mov eax, user_First_Number
			call WriteDec

			mov edx, OFFSET minus_Sign
			call WriteString

			mov eax, user_Second_Number
			call WriteDec 

			mov edx, OFFSET equal_Sign
			call WriteString

			mov eax, difference
			call WriteDec
			call CrLf

		; Displaying Product
			mov eax, user_First_Number
			call WriteDec

			mov edx, OFFSET times_Sign
			call WriteString

			mov eax, user_Second_Number
			call WriteDec 

			mov edx, OFFSET equal_Sign
			call WriteString

			mov eax, product
			call WriteDec
			call CrLf

		; Displaying Product and remainder
			mov eax, user_First_Number
			call WriteDec

			mov edx, OFFSET division_Sign
			call WriteString

			mov eax, user_Second_Number
			call WriteDec 

			mov edx, OFFSET equal_Sign
			call WriteString

			mov eax, quotient
			call WriteDec

			mov edx, OFFSET remainder_String
			call WriteString

			mov eax, remainder
			call WriteDec
			call CrLf

	; Repeats if user hits 1
		call CrLf
		mov edx, OFFSET continue
		call WriteString
		call CrLf

		mov edx, OFFSET if_1
		call WriteString
		call CrLf

		mov edx, OFFSET repeat_Choice
		call ReadInt
		mov repeat_Choice, eax

		.IF eax == 1
			call main
		.ENDIF

	.ELSE
		mov edx, OFFSET second_Bigger
		call WriteString
		call CrLf
		

	.ENDIF	; ends first if statement


	

; Saying Goodbye
	call CrLf
	mov edx, OFFSET goodbye
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
