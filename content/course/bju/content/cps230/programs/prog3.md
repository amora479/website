---
layout: page
title: "Program 3: BMP File Reader"
---

# Overview

You will write a DOS program (COM executable) that can load metadata from (and perhaps display) uncompressed 256-color BMP files.

# BMP File Format

The BitMaP (BMP) image file format originated with Microsoft Windows in the mid 1980s.  It has grown in complexity over the years
as graphics and imaging technology has advanced, but we're going to work with a bare-bones subset of its features.  Start by taking a look
at the following diagram (public domain, swiped from everybody's favorite source, Wikipedia):

![BMP File Format Diagram]({{site.baseurl}}/images/bmp_file_format.png)

Like I said: it's gotten complicated.  But what you care about for this program is just the following:

* The "signature" value (2 bytes, offset 0); this must be the ASCII characters `BM` (0x42, 0x4D)
* The "file offset to pixel array" value (4 bytes, offset 0x0A) *[90 level and beyond]*
* The "image width" value (4 bytes, offset 0x12)
* The "image height" value (4 bytes, offset 0x16)
* The "bits per pixel" value (4 bytes, offset 0x1C)
* The "compression" value (4 bytes, offset 0x1E)
* The "colors in color table" value (4 bytes, offset 0x2E) *[100 level]*
* The color table itself (beginning offset 0x36) *[100 level]*
    * 4 bytes per color
    * byte[0] == blue value (0-255)
    * byte[1] == green value (0-255)
    * byte[2] == red value (0-255)
    * byte[3] == zero (ignore it)
* The pixel array (beginning at whatever offset was indicated by the "file offset to pixel array" value) *[90 level and beyond]*
    * Each "row" consists of WIDTH bytes of pixel data *(with WIDTH possibly rounded up to the nearest multiple of 4)*
    * There are HEIGHT rows
    * The rows are stored *upside-down* (the first row in the file is the *bottom* row of the image on screen)


# Assumptions

You may assume for this program that:

* You will be given either *no* command-line argument or *one* command-line argument
* Multi-byte values in the BMP file may be copied directly into x86 registers (no endian-transformation required) *[this is actually always true]*
* Only the bottom/first 16 bits of 32-bit values in the BMP file matter (i.e., you may ignore the upper half of 32-bit values in the BMP file)
* The files you will receive will be either
    * Well-formed BMP files **OR**
    * Not BMP files at all (i.e., missing the `BM` signature)


# Some Code

For your help and sanity, see the following function that will find/sanitize a single command line argument (the only one you need):

~~~~~~~~~~~~~~~~~~~~~~~~
; Get a pointer to the first command-line argument
;   (convert all WS chars before/after into NULs)
; Takes: nothing
; Clobbers: AX, BX, CX, and DX
; Returns: pointer to NUL-terminated arg in DS:DX
getarg:
	xor	cx, cx
	mov	cl, [0x80]	; number of chars in cmdline buffer 
	mov	bx, 0x0081	; ptr into PSP (cmdline buffer)
	xor	dx, dx		; haven't found it yet
.loop:
	mov	al, [bx]
	cmp	al, `\t`
	je	.ws
	cmp	al, `\r`
	je	.ws
	cmp	al, `\n`
	je	.ws
	cmp	al, ' '
	je	.ws
	
	test	dx, dx
	jnz	.skip
	mov	dx, bx
	jmp	.skip
.ws:
	mov	byte [bx], 0
.skip:
	inc	bx
	loop	.loop
	
	mov	byte [bx], 0	; overwrite final '\r'

	ret
~~~~~~~~~~~~~~~~~~~~~~~~

As you write your own functions for this program, **follow the documentation convention** established in the above example, including:

* Description
* List of arguments and how they are passed (e.g., on the stack, in registers, etc.)
* List of registers "clobbered"/trashed by this function
* Value returned, and in what register[s]

Remember, we're not in Win32-land anymore, so we are not required to abide by the Win32 C calling convention (and DOS most definitely does not).

# Basic Requirements (Max Score: 80%)

Your program must accept a single command-line argument (`FILENAME`) and print out the dimensions, color depth, and compression level of the given
BMP file (if it is a BMP file!).  All numbers output should be in *hexidecimal*.  You may test your program with
these [sample]({{site.baseurl}}/images/prog3_basic.bmp) [images]({{site.baseurl}}/images/prog3_babyj.bmp).  (You should also test it against
non-BMP files.)

## Example Output (Test BMP)

        BMP image is 0140x00C8 pixels at 0008 bits-per-pixel and 0100 colors.
        It is NOT compressed.

## Example Output (non-BMP file)

        That's not a BMP file!

## Hints

* Write a function that can print a 16-bit hexadecimal number (passed in, e.g., `AX`) to the screen using the DOS character output system call (`ah=0x02`)

* Use the DOS file I/O system calls to open (`ah=0x3d`), seek around inside (`ah=0x42`), and read (`ah=0x3f`) from `FILENAME`

* Most DOS system calls *set the carry flag (CF)* if an error occurred, making it really easy to check for an error; e.g.:

        ; set up DOS system call...
        int 0x21

        ; Did something go wrong?
        jc oops_something_bad

        ; Nope--carry on...

* Have a global error handling "function" that exits to DOS (after, perhaps, printing an error message); if any DOS system calls indicate an error/failure,
    jump to this error handler to bail out

* Keep everything as simple as possible.  Use global variables for things like keeping track of your DOS file "handle" and any file I/O buffers you create. 
    

# Intermediate Requirements (Max Score: 90%)

After displaying the image stats, pause (wait for the user to press a key) and then switch into VGA graphics mode to display the contents of the BMP file.
Pause again, and after the user presses a key, switch back to text mode and exit to DOS.

Do this *only* if the BMP file:

* Is exactly 320 pixels wide
* By exactly 200 pixels tall
* Using exactly 8-bits per pixel
* With no compression (i.e., the "compression" field was all zeros)

If any of the above are not true, simple show the stats and exit (without pause) as you did in the max-80 level.

## Example (with the Baby J BMP)

![Baby J, with a sadly messed up palette]({{site.baseurl}}/images/prog3_max90_babyj.png)

Note that we haven't set the palette properly, so the colors have come out all wrong.  (That's OK for this grade level.)

## Hints

* Remember that the raster (i.e., pixel) rows are *reversed* in the file (the *first* row in the file is the *last*/*bottom* row on screen)
* Reading 320 bytes from the file into a memory buffer is relatively easy using DOS, but getting it into the framebuffer is trickier
* You *could* set things up to read *directly* from the file into the framebuffer, but this would require you to set `DS` to `0xA000` (since
    DOS always uses `DS` as the destination segment when reading from files)
* It's probably easier to read into a temporary buffer in your data segment, then *copy* this buffer's contents into the framebuffer
* The "string" instructions (e.g., `rep movsb`) are your friends, along with `std`...


# Advanced Requirements (Max Score: 100%)

When displaying the image in VGA mode, reset the VGA palette to match the color specifications in the BMP color table, so that
the image displays with the proper colors.

## Example

![That's better]({{site.baseurl}}/images/prog3_max100_babyj.png)

That's more like it!

# Report

Fill out the [standard program report template]({{site.baseurl}}/downloads/report_template.docx) DOCX file and print it out.

Also print out your source code using a fixed-width font; if the code takes up more than one page, be sure to print it out "two up" (2 logical pages of code printed side-by-side on each physical page of paper).

Visual Studio does a nice job of printing code in a good monospace font with nice touches like page numbers and the name of the file being printed.

# Submission

Use the submission system to submit your code in a single NASM source file named `prog3.asm`.

Turn in your printed report in person at the beginning of class on the due date.
