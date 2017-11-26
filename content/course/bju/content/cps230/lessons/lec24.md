---
title: "CPS 230 Lecture 24"
---

# Lecture 24: Interrupts

We've already looked at how to execute an interrupt manually, the `int` instruction right?  What if I told you that hex number is just an index and that you can use your own interrupt in place of an OS / BIOS provided one?

You're likely response is why would anyone want to do that.  There are a couple of reasons actually.  The most common is you need a task to execute on a fixed period.  You can change the 0x8th interrupt with your own code.  If you do, your code will run 18.2 times per second.  The other, which we'll discuss today, is getting keyboard input without waiting (useful for games).

## Interrupt Vector Table

Remember that we said addresses 0x0 to 0x400 were special.  They contain the Interrupt Vector Table.  The interrupt number is just an index into this array.  Each entry in this table is 32 bits (not 16!!!).  The first 16 bits are the address of the first instruction of the interrupt function and the second 16 bits are the segment the function is contained within.

To overwrite an interrupt, just simply replace the table entry with your own.  Make sure to save the current values first though.  DOS doesn't always restore the original values.  You want to do that before you exit, otherwise, DOS may not work like you expect after exiting.

## Custom Interrupt

We'll hook into interrupt 0x9 which is the hardware keyboard interrupt.  One last thing before I show you how to save the previous interrupt handler and load your own.  You'll want to turn off hardware interrupts temporarily using `cli` and then turn them back on with `sti` after you're done.

``` asm
bits 16

org 0x100

SECTION .text
main:
	cli
	mov ax, 0
	mov es, ax

	; save the old hander
	mov dx, [es:0x9*4]
	mov [previous9], dx
	mov ax, [es:0x9*4+2]
	mov [previous9+2], ax

	; register your own
	mov dx, keyboard ; keyboard is the name of your custom function
	mov [es:0x9*4], dx
	mov ax, cs 
	mov [es:0x9*4+2], ax
	sti

...

SECTION .data
	previous9: dd 0
```

When writing a handler, one thing to keep in mind is "don't use ret", there is a special instruction for returning from an interrupt, `iret`. We also need to read from the raw hardware port (the keyboard port is 0x60 btw).  We can read a byte on this port using the `in` instruction. Finally keyboards expect an acknowledgement event.  Send 0x20 on port 0x20 to accomplish this.

``` asm
bits 16

org 0x100

SECTION .text

...

keyboard:
	push ax
	in al, 0x60
	mov [number], al
	mov al, 0x20
	out 0x20, al
	pop ax
	iret

SECTION .data
	number: db 0
	previous9: dd 0
```

Note, you can process the keypress directly in the handler, but that isn't a good idea.  Its best to pass the key via a global to your main function.  Processing heavily in the keyboard interrupt can lead to problems because hardware interrupts can't be interrupted by other hardware interrupts.  If your interrupt handler does too much, you can actually start losing keypress events.

One final thing to note, you are not going to receive ascii characters via the keyboard port, you'll receive hardware event codes.  For each keypress you'll receive two events, a keydown and keyup event code.  The helpful program below prints the hex value of those events (until the q [scan code 0x10] key is pressed anyway).

## Full Example

``` asm
bits 16

org 0x100

SECTION .text
main:
	cli
	mov ax, 0
	mov es, ax

	mov dx, [es:0x9*4]
	mov [previous9], dx
	mov ax, [es:0x9*4+2]
	mov [previous9+2], ax

	mov dx, keyboard
	mov [es:0x9*4], dx
	mov ax, cs 
	mov [es:0x9*4+2], ax
	sti

loop_until_q:
	cmp byte [number], 0
	je loop_until_q

	cmp byte [number], 0x10
	jne print_scan_code
	jmp finish
print_scan_code:
	; print top hex digit
	mov al, [number]
	shr al, 4
	and al, 0xF
	call printNybleAsHex

	; print bottom hex digit
	mov al, [number]
	and al, 0xF
	call printNybleAsHex

	mov ah, 0xE
	mov al, 13
	int 0x10

	mov ah, 0xE
	mov al, 10
	int 0x10

	mov byte [number], 0
	jmp loop_until_q 

finish:
	mov dx, [previous9]
	mov [es:0x9*4], dx
	mov ax, [previous9 + 2]
	mov [es:0x9*4+2], ax

	mov ah, 0x4c
	mov al, 0
	int 0x21

printNybleAsHex:
	cmp al, 10
	jl digit
	add al, 'a'
	sub al, 10
	jmp print
digit:
	add al, '0'
print:
	mov ah, 0xE
	int 0x10
	ret

keyboard:
	push ax
	in al, 0x60
	mov [number], al
	mov al, 0x20
	out 0x20, al
	pop ax
	iret

SECTION .data
	number: db 0
	previous9: dd 0
```