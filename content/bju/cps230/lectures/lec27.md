---
title: "CPS 230"
date: 2018-08-21T00:00:00-04:00
draft: true
---

# Lecture 27: 64-bit Assembly

## Registers

64-bit assembly introduces new registers names, and new ways to access sub-registers.  For example, consider the RAX regiser.  To access the full 64 bits of the register, RAX is used.  To access the lower 32 bits, EAX (like 32-bit assembly) is used.  AX can be used to access the lower 16 bits.  Of those lower 16 bits, you can access the high byte with AH and the lower byte with AL.

This is true for the remaining legacy registers: RBX, RCX, RDX.  RBP, RSI, RDI and RSP can be accessed in 64-bit mode (RBP, RSI, RDI, RSP), 32-bit mode (EBP, ESI, EDI, ESP), or 16-bit mode (BP, SI, DI, SP).  Note, there is no splitting into a lower / high byte for these registers.

Finally, there are 8 new general purpose registers added to the set, R8-R15. Like the other registers, these have several different use modes.  They can be accessed in 64-bit mode (R<8-15>), 32-bit mode (R<8-15>D), 16-bit mode (R<8-15>W) and 8-bit mode (R<8-15>L).  For these registers, there is no high byte of the lower 16 bits, just a lower byte.

## Calling Conventions

Calling functions in 64-bit assembly is a bit different than what you might expect.  Parameters are no longer passed strictly via the stack.  If a function, requires 4 or less parameters, the parameters are passed via RCX, RDX, R8 and R9.  Additional parameters are passed via the stack. Also note, it is no longer typical to place an underscore before function names.

RAX, RCX, RDX, R8, R9, R10, and R11 are considered volitale and callers should not consider their values to be preserved after a call. RBX, RBP, RDI, RSI, R12, R14, R14, and R15 are considered non-volitale and functions should save and restore their values if the registers are used.

## Shadow Space

One odd feature of x64 assembly is the reservation of shadow space (in case the RCX, RDX, R8, R9 registers need to be saved / restored). It is the job of the caller to setup this space before functions are called, not the callee!

## Compiling / Linking with NASM

The command for compiling with NASM in 64-bit mode is `nasm -f win64 <asm files>`.  The link command is the same as what we used earlier in the semester `cl /Zi msvcrt.lib legacy_stdio_definitions.lib <obj file>`.  The only difference is you now run this command in the x64 native command line tools instead of the x86.

## Hello World in 64-bit Assembly

``` asm
extern	printf		

section .data		
	msg:	db "Hello world", 0	
	fmt:    db "%s", 10, 0  

section .text           

global main		
main:				
    push        rbp  
	push        rdi  
	sub         rsp,0E8h      ; reserve shadow space
    lea         rbp,[rsp+20h] ; reserve shadow space 
    
    mov         rdx,msg  
    mov         rcx,fmt  
    call        printf   
      
    lea         rsp,[rbp+0C8h] ; pop shadow space
    pop         rdi  
	pop         rbp
	mov         rax, 0
	ret
```

## Hello <Name> in 64-bit Assembly

``` asm
extern	printf		
extern  scanf

section .data
    name:   db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    query:  db "What is your name? ", 0
	msg:	db "Hello", 0	
	fmt1:   db "%s", 0
	fmt2:   db "%s %s", 10, 0

section .text           

global main		
main:				
    push        rbp  
	push        rdi  
	sub         rsp,0E8h      ; reserve shadow space
    lea         rbp,[rsp+20h] ; reserve shadow space 
    
    mov         rdx, query  
    mov         rcx, fmt1
    call        printf   
    
    mov         rdx, name
    mov         rcx, fmt1
    call        scanf

    mov         r8, name
    mov         rdx, msg
    mov         rcx, fmt2
    call        printf
      
    lea         rsp,[rbp+0C8h] ; pop shadow space
    pop         rdi  
	pop         rbp
	mov         rax, 0
	ret
```