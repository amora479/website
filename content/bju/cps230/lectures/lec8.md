---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 8: Registers, Flags and Bit Manipulation

## Assembly Commands

Last time we said that assembly commands followed the general pattern of `opcode parameter, parameter`.  We also said that not all instructions use all parameters.  However, these parameters do have names!  The reason for the names will (hopefully) be more obvious throughout this lecture.  The first parameter is called the `destination operand` and the second parameter is called the `source operand`.

These values can be many things (but what they can be depends, to find out possible combinations, check the [Assembly Bible](/course/bju/content/cps230/downloads/64ia32_isa_ref.pdf)).  These things fall into one of three categories.

### Immediate Values

Assembly allows you to directly put a raw value into a register or memory address.  It also, like C, allows you to specifiy if the number is decimal, binary or hex.  Like C, decimal numbers are the default so if you write a number, it is assumed to be decimal (-ish, if the number contains letters, the assembler can generally figure out you want hex, but this depends on the assembler).

You can also specify a number is decimal by appending a d to the end, like this `1234d`.  Hex numbers are written exactly as they are in C, `0x1234A`.  Binary numbers are written like decimal numbers in assembly, except you append a `b`, like this `0110100b`.

### Registers

Assembly allows you to directly reference the registers of the processor (at least most of them).  In 32-bit Intel-based assembly, we have access to 8 32-bit registers: EBP, ESP, ESI, EDI, EAX, EBX, ECX, EDX.  About half of these registers serve special purposes, and we can divide the registers into two categories.

#### General Purpose Registers

The General Purposes Registers (EAX, EBX, ECX, EDX) are the ones that you will most commonly modify.  The registers are also special because they are backwards compatible with the 8-bit and 16-bit programming days.  To accomplish this, certain parts of the register are "named".

``` text
00000000 00000000 00000000 00000000
-----------------------------------
                EAX
00000000 00000000 00000000 00000000
                  -----------------
                          AX
00000000 00000000 00000000 00000000
                  -------- --------
                     AH       AL
```

The full 32-bits bears the `E?X` name.  The bottom 16-bits bears the `?X` name.  Finally, of those bottom 16 bits, the top 8 can be referenced using `?H` and the bottom 8 can be referenced using `?L`.

#### Special Purpose Registers 

The Special Purposes Registers (EAX, EDI, ESI, EBP, EBP) are reserved and shouldn't be used unless necessary.  And if used, you should save their value on the stack so you can restore after you are done.  This really only applies to (EAX, EDI and ESI).  You should **NEVER** use EBP and ESP unless you are manipulating the stack.  ESP points to the top of the stack, and EBP points to the stacks current base frame (we'll talk about base frames when we talk about functions).

The reason that EAX is in this list.  EAX always holds the return value of a function call!  So if you are using EAX, and you call a function, make sure to save the value in eax before you call the function so you can restore it later.

### Memory

We've already looked how memory is referenced in assembly, using square brackets `[address]`.  There are three types of memory references: direct, indirect and offset.  Direct access means that you are putting an immedate value into the address of the memory reference, i.e. `[1234]`.  Indirect means that you stick the address into a register first, then reference memory, i.e. `[eax]`.  Offset means that you are using both methods, i.e. `[eax+4]`.

## Flags

Flags in assembly are stored in a special register, and there are quite a few of them.  For example, the overflow flag tells us if an addition or subtraction operation overflowed.  There is also a carry flag to tell us if an operation carried.  There are others that we'll look at throughout the course of the semester.  For now, just remember: Flags are all stored in the bits of a single register and those flags are manipulated as side-effects of certain instructions.  We'll use these side effects next class period.

## Calling Printf

Let's take a short side trip to talk about how functions are called in C.  First, the parameters are passed via the stack (using `push`), and they are passed in reverse order.  This way, the first parameter is at the top of the stack, and other parameters follow.

``` asm
extern _printf

SECTION .data

	fmt:    db "%x", 10, 0

SECTION .text

global _main
_main:
   	push	eax
    push    fmt
    call    _printf
    add     esp, 8
    ret
```

So let's look at calling printf.  First, since printf isn't defined in assembly (but a C library), we need to let the assembly know the definition will be provided later.  This is accomplished by the `extern _printf` statement.

Second, printf requires a format string as its first parameter.  For now, we aren't going to worry about the specifics, but you can define a C string like this `fmt: db "%x", 10, 0` or more generically `<string name>: db <string here>, 10, 0`. We'll talk about the `db`, 10 and 0 later this semester.

Finally, since we are passing values via the stack, we also need to pop them off after we are done.  This can be done using the `pop` instruction or you can directly modify the stack pointer (ESP).  Adding to the stack pointer will pop values off.  Since we are working in 32-bit land, simply add `4 * <number of parameters>` to the stack.

The above snippet of code prints the EAX register in hexadecimal, and then pops the format string and eax off the stack by adding 8 (4 * 2 parameters) to ESP.

## Bit Manipulation

Assembly has the same (plus a few extra) bit manipulation operations as assembly.  You can and, or, and xor.

``` asm
extern _printf

SECTION .data

	fmt:    db "%x", 10, 0

SECTION .text

global _main
_main:
	mov 	eax, 0xFF00
	mov 	ebx, 0x00FF
	and 	ebx, eax
   	push	eax
    push    fmt
    call    _printf
    add     esp, 8
    ret
```

Let's inspect this a little more closely, particularly, those 3 lines I added :).  `mov` copies the value of the source operand into the destination operand.  If you look at the Assembly Bible, you'll notice that mov requires a register or memory location as its destination operand.  The first two lines `mov eax, 0xFF00` and `mov ebx, 0x00FF` set eax to 0xFF00 and ebx to 0x00FF respectively.  Finally, `and eax, ebx` ands the values in eax and ebx then stores the result in the destination operand (in this case eax).  `or` and `xor` operate the same way.

Shifting is another common task that we did in C.  There are two commands for shifting right and left (`shr` and `shl` respecitvely), but these are unsigned shifts.  Remember that we originally said shifting was a quick way to multiply and divide?  There are also shifts that preserve your sign, `sar` and `sal`.  With shifting, the destination operand is the register you want to shift, and the source operand is an immediate value, register, or memory value that contains how many times you want to shift.

Rotating is a new feature of C.  What this allows us to do is copy `x` bits from the bottom or top of a register to the other end.  For exaple, if we were to rotate `01011010` to the left 4 bits, we would have `10100101`.  The top 4 bits were shifted off, the remaining bits shift 4, then the entire registered was or'd with the shifted bits.  `ror` and `rol` allow you to rotate right and left respectively.

## Standard Arithmetic Operations

`add` and `sub` work exactly as `and`.  `sub` is only slightly confusing.  You take the value in the destination operand, subtract from it the source operand, and stick it back in the destination.

Multiply and divide are, sadly, not so simple.  First, there are multiple commands depending on whether you want signed or unsigned operations.  Multiplication has 2: `mul` (unsigned) and `imul` (signed).  Division also has 2: `div` (unsigned) and `idiv` (signed), but there are some helper methods that you also need: `cbw/cwde/cdqe`.

Second, remember how when we did binary division and multiplication, the sizes of the operands and result were different?  For division, the dividend is twice as large as the divisor and quotient.  For multiplication the answer is twice the size of the operands.  That applies in assembly.

Let's look at multiplication first.  If you look at the definition of `mul` in the Intel manual, there are several definitions. We are really only concerned with the first few.  To multiply two 8 bit numbers, we copy one into AL and the second somewhere else.  We then call `mul` with the second location and the result is stored in AX.

``` asm
extern _printf

SECTION .data

	fmt:    db "%x", 10, 0

SECTION .text

global _main
_main:
	mov     eax, 0d
	mov 	al, 4d
	mov 	bl, 3d
	mul     bl
   	push	eax
    push    fmt
    call    _printf
    add     esp, 8
    ret
```

This is also true for 16-bit multiplication as well as 32-bit multiplication, with one caveat.  The answer is split across multiple registers!  With 16-bit multiplication, the top 16 bit are in DX and the bottom are in AX.  With 32-bit, the top 32-bits are in EDX and EAX has the bottom 32.

Division is very similar, just in reverse.  The divisor is spread across EDX:EAX and the dividend is put into another register.  You then call `div` or `idiv` with the second register. The quotient goes into EAX and the remainder is put into EDX. (Hey, look you get mod and divide for the price of one command!)

``` text
For 16-bit: Dx:AX / <16-bit register> => AX = Quotient, DX = Remainder
For 8-bit: AX / <8-bit register> => AL = Quotient, AH = Remainder
```