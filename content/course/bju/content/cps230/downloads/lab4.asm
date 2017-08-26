; CpS 230 Lab 4: Alice B. College-Student (acoll555)
;---------------------------------------------------
; Warm-up lab exercise to introduce the basics of
; writing, building, and running IA-32 assembly code
; programs on Windows.
;---------------------------------------------------
bits 32

; We use these functions (printf and scanf) from an external library
extern _printf
extern _scanf

; Begin the "code" section of our output OBJ file
section .text

; Mark the label "_main" as an exported/global symbol
global _main

; "_main" marks the spot where our code actually is (i.e., calling "main()" takes you here)
_main:
	; Boilerplate "function prologue"
	push	ebp
	mov	ebp, esp
	
	; Prompt for input [C: printf("Please enter an integer: ");]
	push	str_prompt	; address of format string "Please enter..."
	call	_printf
	pop	eax		; clean off stack
	
	; Read input without checking for input errors [C: scanf("%d", &int_number);]
	push	int_number	; address of DWORD sized variable int_number
	push	str_pattern	; address of format string "%d"
	call	_scanf
	pop	eax		; clean off stack
	pop	eax
	
	; Add number to itself [C: int_number += int_number;]
	mov	eax, [int_number]	; <eax> = int_number
	add	[int_number], eax	; int_number += <eax>
	
	; Print modified number [C: printf("Your number added to itself is: %d\n", int_number);]
	push	dword [int_number]	; VALUE, not address, of variable int_number
	push	str_output		; address of format string "Your number..."
	call	_printf
	pop	eax			; clean off stack
	pop	eax
	
	; Put our return value in the <eax> register [C: return 0;]
	mov	eax, 0
	
	; Boilerplate "function epilogue"/return
	pop	ebp
	ret

; Begin the "data" section of our output OBJ file
section .data

; Reserve memory for various 0-terminated strings and mark their starting points in memory with labels
str_prompt	db	"Please enter an integer: ", 0
str_pattern	db	"%d", 0
str_output	db	"Your number added to itself is: %d", 10, 0

; Reserve a DWORD (4 bytes) for an integer variable; mark its starting point in memory with the label "int_number"
int_number	dd	0
