---
title: "CPS 230 Lecture 21"
---

# Lecture 21: VGA Graphics

There are two ways of drawing onto the screen: Text and VGA.  We've looked briefly at how to write a character at the current cursor position.  Now let's get a bit more fancy and use memory mapping!

## Text Mode Graphics

In text-mode graphics, the screen's memory map begins at 0xB8000 and each character on the screen is 16 bits.  Each of these 16 bits has a purpose so let's outline them very quickly.

| Bits | Value |
| --- | --- |
| 15 | Blink | 
| 14 - 12 | Background Color |
| 11 - 8 | Foreground Color |
| 7 - 0 | ASCII Value |

Additionally, you'll need to know the color chart :)

| Hex Code | Color |
| --- | --- |
| 0 | Black |
| 1 | Blue |
| 2 | Green |
| 3 | Aqua |
| 4 | Red |
| 5 | Purple |
| 6 | Yellow |
| 7 | White |
| 8 | Gray |
| 9 | Light Blue |
| A | Light Green |
| B | Light Aqua |
| C | Light Red |
| D | Light Purple |
| E | Light Yellow |
| F | Bright White |

Here is a simple ASM program that enables text mode graphics and then prints BJU to the screen with a white font and dark blue background.

``` asm
bits 16

org 0x100

SECTION .text
main:
	mov ax, 0xB800
	mov es, ax
	mov bx, 996

	mov ah, 0x0
	mov al, 0x1
	int 0x10 ; set video to text mode

	mov word [es:bx+0], 0x9F42 ; B dark blue background, white font
	mov word [es:bx+2], 0x9F4A ; J dark blue background, white font
	mov word [es:bx+4], 0x9F55 ; U dark blue background, white font
	mov word [es:bx+6], 0x1F21 ; ! dark blue background, white font

	mov ah, 0x0 ; wait for user input
	int 0x16

	mov ah, 0x4c
	mov al, 0
	int 0x21
```

## VGA Mode Graphics

VGA Mode Graphics are a little bit more complex.  First the screen size is set to 320 x 200.  Second, the memory map has been moved to 0xA0000 and each byte represents a single pixel's color.  The first 16 colors are the same as text mode.  I'll show an example program below that displays the rest :)

``` asm
bits 16

org 0x100

SECTION .text
_main:
	mov ah, 0x0
	mov al, 0x13
	int 0x10 ; set video to vga mode

color_row_loop:
	cmp word [color_row], 13
	jne continue_color_row
	jmp exit
continue_color_row:
	mov word [color_column], 0
color_column_loop:
	cmp word [color_column], 21
	jne continue_color_column
	jmp color_column_done
continue_color_column:
	mov ax, [color_row]
	mov bx, 15
	imul bx
	mov [row], ax

	mov ax, [color_column]
	mov bx, 15
	imul bx
	mov [column], ax

	mov ax, [current_color]
	mov [color], ax

	call _draw_block

	inc word [current_color]

	inc word [color_column]
	jmp color_column_loop
color_column_done:
	inc word [color_row]
	jmp color_row_loop
exit:
	mov ah, 0x0 ; wait for user input
	int 0x16

	mov ah, 0x4c
	mov al, 0
	int 0x21

_draw_block:
	mov dx, 0xA000
	mov es, dx
	
	mov word [row_i], 0
row_loop:
	cmp word [row_i], 15
	jne continue_row
	jmp done_row
continue_row:
	mov word [column_i], 0
column_loop:
	cmp word [column_i], 15
	jne continue_column
	jmp column_done
continue_column:
	
	mov ax, [row]
	add ax, [row_i]
	mov bx, 320
	imul bx

	mov bx, [column]
	add bx, [column_i]
	add bx, ax

	mov cx, [color]

	mov [es:bx], cx

	inc word [column_i]
	jmp column_loop
column_done:
	inc word [row_i]
	jmp row_loop
done_row:
	ret

SECTION .data
	column: dw 0
	row: dw 0
	color: dw 0

	column_i: dw 0
	row_i: dw 0

	color_column: dw 0
	color_row: dw 0
	current_color: dw 0
```