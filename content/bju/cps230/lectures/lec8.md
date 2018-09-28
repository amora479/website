---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: false
---

# Lecture 8: Registers, Flags and Bit Manipulation

## Assembly Commands

Last time we said that assembly commands followed the general pattern of `opcode parameter, parameter`.  We also said that not all instructions use all parameters.  However, these parameters do have names!  The reason for the names will (hopefully) be more obvious throughout this lecture.  The first parameter is called the `destination operand` and the second parameter is called the `source operand`.

These values can be many things (but what they can be depends, to find out possible combinations, check the [Assembly Bible](/bju/cps230/downloads/isa_ref.pdf)).  These things fall into one of three categories.

### Immediate Values

Assembly allows you to directly put a raw value into a register or memory address.  It also, like C, allows you to specifiy if the number is decimal, binary or hex.  Like C, decimal numbers are the default so if you write a number, it is assumed to be decimal (-ish, if the number contains letters, the assembler can generally figure out you want hex, but this depends on the assembler).

You can also specify a number is decimal by appending a d to the end, like this `1234d`.  Hex numbers are written exactly as they are in C, `0x1234A`.  Binary numbers are written like decimal numbers in assembly, except you append a `b`, like this `0110100b`.

### Registers

Assembly allows you to directly reference the registers of the processor (at least most of them).  In 64-bit Intel-based assembly, we have access to 8 32-bit registers: RBP, RSP, RSI, RDI, RAX, RBX, RCX, RDX, R8, R9, R10, R11, R12, R13, R14, R15.  About half of these registers serve special purposes, and we can divide the registers into two categories.

#### General Purpose Registers

The General Purposes Registers (RBX, RCX, RDX, R8, R9, R10, R11, R12, R13, R14, R15) are the ones that you will most commonly modify.  The registers are also special because they are backwards compatible with the 8-bit, 16-bit and 32-bit programming days.  To accomplish this, certain parts of the register are "named". The RAX, RSP, RBP, RDI and RSI registers are also important, but each has a special purpose that will discuss.

The R_X series registers use the following conventions. The full 64-bits bears the `R?X` name. The full 32-bits bears the `E?X` name.  The bottom 16-bits bears the `?X` name.  Finally, of those bottom 16 bits, the top 8 can be referenced using `?H` and the bottom 8 can be referenced using `?L`.

``` text
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
-----------------------------------------------------------------------
                                  R_X

00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                    -----------------------------------
                                                    E_X
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                      -----------------
                                                              _X
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                      -------- --------
                                                         _H       _L
```

The R# registers are newer registers and follow a slightly different format. The full 64-bits bears the `R?` name. The full 32-bits bears the `R?d` name.  The bottom 16-bits bears the `R?w` name.  Finally, the bottom 8 bits can be referenced as `r?b`.

``` text
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
-----------------------------------------------------------------------
                                   R_

00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                    -----------------------------------
                                                    R_d
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                      -----------------
                                                             R_w
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                               --------
                                                                  R_b
```

The RBP, RSP, RDI and RSI registers follow a convention mixing the two previous conventions. The full 64-bits bears the `R??` name. The full 32-bits bears the `E??` name.  The bottom 16-bits bears the `??` name.  Finally, the bottom 8 bits can be referenced as `??l`.

``` text
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
-----------------------------------------------------------------------
                                  R__

00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                    -----------------------------------
                                                    E__
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                      -----------------
                                                              __
00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
                                                               --------
                                                                  __l
```

All of difference in naming conventions basically stems from backwards compatibility and making things easier for new creations. 

#### Special Purpose Registers 

The Special Purposes Registers (RAX, RDI, RSI, RBP, RBP) are reserved and shouldn't be used unless necessary.  And if used, you should save their value on the stack so you can restore after you are done.  This really only applies to (RAX, RDI and RSI).  You should **NEVER** use RBP and RSP unless you are manipulating the stack.  RSP points to the top of the stack, and RBP points to the stacks current base frame (we'll talk about base frames when we talk about functions).

The reason that RAX is in this list is RAX always holds the return value of a function call!  So if you are using RAX, and you call a function, make sure to save the value in eax before you call the function so you can restore it later.

### Memory

We've already looked how memory is referenced in assembly, using square brackets `[address]`.  There are three types of memory references: direct, indirect and offset.  Direct access means that you are putting an immedate value into the address of the memory reference, i.e. `[1234]`.  Indirect means that you stick the address into a register first, then reference memory, i.e. `[rax]`.  Offset means that you are using both methods, i.e. `[rax+4]`.

## Flags

Flags in assembly are stored in a special register, and there are quite a few of them.  For example, the overflow flag tells us if an addition or subtraction operation overflowed.  There is also a carry flag to tell us if an operation carried.  There are others that we'll look at throughout the course of the semester.  For now, just remember: Flags are all stored in the bits of a single register and those flags are manipulated as side-effects of certain instructions.  We'll use these side effects next class period.

## Calling Printf

Let's take a short side trip to talk about how functions are called in C.  First, the four parameters are passed via registers (rcx, rdx, r8, r9), and anything after that is pushed in reverse order onto the stack.  This way, the fifth parameter is at the top of the stack, and other parameters follow.  Also anytime you are using c standard library functions, the shadow space creation and removal are absolutely required.

``` asm
bits 64
default rel

extern printf

SECTION .data

	fmt:    db "%x %x %x %x %x %x", 10, 0

SECTION .text

global main
main:
    push    6
    push    5
    push    4
    sub     rsp, 32
    mov     r9, 3
    mov     r8, 2
    mov     rdx, 1
    mov     rcx, fmt
    call    printf
    add     rsp, 56 ; 8 bytes (64 bits) * 3 + 32

    mov     rax, 0
    ret
```

So let's look at calling printf.  First, since printf isn't defined in assembly (but a C library), we need to let the assembly know the definition will be provided later.  This is accomplished by the `extern printf` statement.

Second, printf requires a format string as its first parameter.  For now, we aren't going to worry about the specifics, but you can define a C string like this `fmt: db "%x", 10, 0` or more generically `<string name>: db <string here>, 10, 0`. We'll talk about the `db`, 10 and 0 later this semester.

Finally, since we are passing values via the stack, we also need to pop them off after we are done.  This can be done using the `pop` instruction or you can directly modify the stack pointer (RSP).  Adding to the stack pointer will pop values off.  Since we are working in 64-bit land, simply add `8 * <number of pushed parameters>` to the stack.

The above snippet of code prints `1 2 3 4 5 6`, and then pops `4 5 6` off the stack by adding 24 (8 * 3 pushed parameters) to RSP.

## Bit Manipulation

Assembly has the same (plus a few extra) bit manipulation operations as assembly.  You can and, or, and xor.

``` asm
bits 64
default rel

extern printf

SECTION .data

    fmt:    db "%x", 10, 0

SECTION .text

global main
main:
    mov     rax, 0xFF00
    mov     rbx, 0x00FF
    and     rbx, rax
    sub     rsp, 32
    mov	    rdx, rbx
    mov     rcx, fmt
    call    printf
    add     rsp, 32
    
    mov     rax, 0
    ret
```

Let's inspect this a little more closely, particularly, those 3 lines I added :).  `mov` copies the value of the source operand into the destination operand.  If you look at the Assembly Bible, you'll notice that mov requires a register or memory location as its destination operand.  The first two lines `mov rax, 0xFF00` and `mov rbx, 0x00FF` set rax to 0xFF00 and rbx to 0x00FF respectively.  Finally, `and rax, rbx` ands the values in rax and rbx then stores the result in the destination operand (in this case rax).  `or` and `xor` operate the same way.

Shifting is another common task that we did in C.  There are two commands for shifting right and left (`shr` and `shl` respecitvely), but these are unsigned shifts.  There are also shifts that preserve your sign, `sar` and `sal`.  With shifting, the destination operand is the register you want to shift, and the source operand is an immediate value, register, or memory value that contains how many times you want to shift.

Rotating is a new feature of C.  What this allows us to do is copy `x` bits from the bottom or top of a register to the other end.  For exaple, if we were to rotate `01011010` to the left 4 bits, we would have `10100101`.  The top 4 bits were shifted off, the remaining bits shift 4, then the entire registered was or'd with the shifted bits.  `ror` and `rol` allow you to rotate right and left respectively.

## Standard Arithmetic Operations

`add` and `sub` work exactly as `and`.  `sub` is only slightly confusing.  You take the value in the destination operand, subtract from it the source operand, and stick it back in the destination.

Multiply and divide are, sadly, not so simple.  First, there are multiple commands depending on whether you want signed or unsigned operations.  Multiplication has 2: `mul` (unsigned) and `imul` (signed).  Division also has 2: `div` (unsigned) and `idiv` (signed), but there are some helper methods that you also need: `cbw/cwde/cdqe`.

Second, remember how when we did binary division and multiplication, the sizes of the operands and result were different?  For division, the dividend is twice as large as the divisor and quotient.  For multiplication the answer is twice the size of the operands.  That applies in assembly.

Let's look at multiplication first.  If you look at the definition of `mul` in the Intel manual, there are several definitions. We are really only concerned with the first few.  To multiply two 8 bit numbers, we copy one into AL and the second somewhere else.  We then call `mul` with the second location and the result is stored in AX.

``` asm
bits 64
default rel

extern printf

SECTION .data

    fmt:    db "%x", 10, 0

SECTION .text

global main
main:
    mov     rax, 0d
    mov     al, 4d
    mov     bl, 3d
    mul     bl
    sub     rsp, 32
    mov	    rdx, rax
    mov     rcx, fmt
    call    printf
    add     rsp, 32
    
    mov     rax, 0
    ret
```

This is also true for 16-bit multiplication as well as 32-bit multiplication, with one caveat.  The answer is split across multiple registers!  With 16-bit multiplication, the top 16 bit are in DX and the bottom are in AX.  With 32-bit, the top 32-bits are in EDX and EAX has the bottom 32. With 64-bit, the top 64-bit are in RDX and the bottom are in RAX.

Division is very similar, just in reverse.  The divisor is spread across RDX:RAX and the dividend is put into another register.  You then call `div` or `idiv` with the second register. The quotient goes into RAX and the remainder is put into RDX. (Hey, look you get mod and divide for the price of one command!)

``` text
For 32-bit: EDX:EAX / <32-bit register> => EAX = Quotient, EDX = Remainder
For 16-bit: DX:AX / <16-bit register> => AX = Quotient, DX = Remainder
For 8-bit: AX / <8-bit register> => AL = Quotient, AH = Remainder
```
